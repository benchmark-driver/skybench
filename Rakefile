require 'bundler'
require 'fileutils'
require 'shellwords'
require 'yaml'

definition_dir = File.expand_path('benchmark/definitions', __dir__)
repeat_count_by_pattern = {
  'mjit-benchmarks/benchmarks/*.yml' => 1,
  'ruby-benchmarks/benchmarks/*.yml' => 1,
  'ruby-method-benchmarks/benchmarks/**/*.yml' => 1,
  'optcarrot/benchmark.yml' => 4,
}
release_versions = [
  '2.0.0-p648',
  '2.1.10',
  '2.2.9',
  '2.3.6',
  '2.4.3',
  '2.5.0',
  '2.6.0-preview1',
  '2.6.0-preview1 --jit',
]

module BenchmarkRunner
  def self.run(result_yaml:, definition_yaml:, versions:, repeat_count:)
    Bundler.with_clean_env do
      ENV['RESULT_YAML'] = result_yaml
      command = [
        'bin/benchmark-driver', '-o', 'skybench', definition_yaml,
        '--rbenv', versions.join(';'), '--timeout', '60',
        '--repeat-count', repeat_count.to_s,
      ].shelljoin

      puts "+ #{command}"
      unless system(command) # Keep running even on failure of each benchmark execution
        puts "Failed to execute: #{command}"
      end
    end
  end
end

desc 'Update releases'
task :releases do
  repeat_count_by_pattern.each do |pattern, repeat_count|
    Dir.glob(File.join(definition_dir, pattern)).sort.each do |definition_yaml|
      definition = YAML.load_file(definition_yaml)
      result_yaml = File.join('benchmark/results', definition_yaml.delete_prefix(definition_dir))

      # Decide which versions to run
      if File.exist?(result_yaml)
        versions = []
        YAML.load_file(result_yaml).fetch('results').each do |name, results|
          # Select missing versions
          missing_versions = release_versions - (results || {}).keys
          required_ruby_version = definition['required_ruby_version']
          if definition['benchmark'].is_a?(Array) && (job = definition['benchmark'].find { |j| j['name'] == name }) && job.key?('required_ruby_version')
            required_ruby_version = job['required_ruby_version']
          end
          if required_ruby_version
            missing_versions.select! { |v| Gem::Version.new(v.sub(/ --jit\z/, '')) >= Gem::Version.new(required_ruby_version) }
          end

          versions |= missing_versions
        end
      else
        versions = release_versions
        FileUtils.mkdir_p(File.dirname(result_yaml))
      end

      # Run benchmark if necessary
      unless versions.empty?
        Bundler.with_clean_env do
          ENV['RESULT_YAML'] = result_yaml
          command = [
            'bin/benchmark-driver', '-o', 'skybench', definition_yaml,
            '--rbenv', versions.join(';'),
            '--repeat-count', repeat_count.to_s,
          ].shelljoin

          puts "+ #{command}"
          unless system(command) # Keep running even on failure of each benchmark execution
            puts "Failed to execute: #{command}"
          end
        end
      end
    end
  end
end

desc 'Update benchmarks for only the oldest revision'
task :revisions do
  all_revisions = IO.popen('rbenv versions --bare', &:read).split("\n").select { |v| v.match?(/\Ar\d+\z/) }
  repeat_count_by_pattern.each do |pattern, repeat_count|
    Dir.glob(File.join(definition_dir, pattern)).sort.each do |definition_yaml|
      definition = YAML.load_file(definition_yaml)
      result_yaml = File.join('benchmark/results', definition_yaml.delete_prefix(definition_dir))

      # Decide which revision to run
      if File.exist?(result_yaml)
        versions = []
        YAML.load_file(result_yaml).fetch('results').each do |name, results|
          # Select missing versions
          finished_revisions = all_revisions & (results || {}).keys
          missing_revisions = all_revisions - finished_revisions

          unless missing_revisions.empty?
            future_revisions = missing_revisions.select { |r| r > finished_revisions.last }
            if future_revisions.size > 10
              versions << future_revisions[10]
            else
              versions << missing_revisions.last
            end
          end
        end
        versions.uniq!
      else
        versions = [all_revisions.first]
        FileUtils.mkdir_p(File.dirname(result_yaml))
      end

      # Run benchmark if necessary
      unless versions.empty?
        BenchmarkRunner.run(
          result_yaml: result_yaml,
          definition_yaml: definition_yaml,
          versions: versions,
          repeat_count: repeat_count,
        )

        # Run --jit for r62197+ https://github.com/ruby/ruby/commit/ed935aa5be0e5e6b8d53c3e7d76a9ce395dfa18b
        jit_versions = versions.select do |revision|
          Integer(revision.delete_prefix('r')) >= 62197
        end.map { |revision| "#{revision} --jit" }

        unless jit_versions.empty?
          BenchmarkRunner.run(
            result_yaml: result_yaml,
            definition_yaml: definition_yaml,
            versions: jit_versions,
            repeat_count: repeat_count,
          )
        end
      end
    end
  end
end

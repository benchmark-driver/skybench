require 'bundler'
require 'fileutils'
require 'shellwords'
require 'yaml'

release_versions = [
  '2.0.0-p648',
  '2.1.10',
  '2.2.9',
  '2.3.6',
  '2.4.3',
  '2.5.0',
  '2.6.0-preview1',
]

desc 'Update releases'
task :releases do
  definition_dir = File.expand_path('benchmark/definitions', __dir__)
  repeat_count_by_pattern = {
    'mjit-benchmarks/benchmarks/*.yml' => 1,
    'ruby-benchmarks/benchmarks/*.yml' => 1,
    'ruby-method-benchmarks/benchmarks/**/*.yml' => 1,
    'optcarrot/benchmark.yml' => 4,
  }

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
          if definition['benchmark'].is_a?(Hash) && definition['benchmark'][name].is_a?(Hash) && definition['benchmark'][name].key?('required_ruby_version')
            required_ruby_version = definition['benchmark'][name]['required_ruby_version']
          end
          if required_ruby_version
            missing_versions.select! { |v| Gem::Version.new(v) >= Gem::Version.new(required_ruby_version) }
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

task default: :releases

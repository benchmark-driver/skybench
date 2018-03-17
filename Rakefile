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
    'optcarrot/benchmark.yml' => 4,
  }

  repeat_count_by_pattern.each do |pattern, repeat_count|
    Dir.glob(File.join(definition_dir, pattern)).sort.each do |definition_yaml|
      result_yaml = File.join('benchmark/results', definition_yaml.delete_prefix(definition_dir))

      # Decide which versions to run
      if File.exist?(result_yaml)
        versions = []
        YAML.load_file(result_yaml).fetch('results').each do |name, results|
          versions |= release_versions - results.keys # add missing versions
        end
      else
        versions = release_versions
        FileUtils.mkdir_p(File.dirname(result_yaml))
      end

      # Run benchmark if necessary
      unless versions.empty?
        Bundler.with_clean_env do
          ENV['RESULT_YAML'] = result_yaml
          sh [
            'bin/benchmark-driver', '-o', 'skybench', definition_yaml,
            '--rbenv', versions.join(';'),
            '--repeat-count', repeat_count.to_s,
          ].shelljoin
        end
      end
    end
  end
end

task default: :releases

names = %i[
  ruby_core
]

release_rubies = [
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
  definition_patterns = [
    'mjit-benchmarks/benchmarks/*.yml',
    'optcarrot/benchmark.yml',
  ]

  definition_patterns.each do |pattern|
    pattern = File.join(definition_dir, pattern)
    Dir.glob(pattern).sort.each do |yaml|
      p yaml
    end
  end

  # Bundler.with_clean_env
  # RESULT_YAML=results/xxx.yml bin/benchmark-driver -o skybench --rbenv 'xxx;yyy' xxx.yml
end

task default: :releases

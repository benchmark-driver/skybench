require 'shellwords'

release_rubies = [
  '2.0.0-p648',
  '2.1.10',
  '2.2.9',
  '2.3.6',
  '2.4.3',
  '2.5.0',
  '2.6.0-preview1',
  '2.6.0-preview1,--jit',
]

task 'benchmarks/mjit-benchmarks' do
  sh 'git submodule init && git submodule update'
end

task 'benchmarks/optcarrot' do
  sh 'git submodule init && git submodule update'
end

desc 'Run MJIT benchmark'
task mjit_releases: 'benchmarks/mjit-benchmarks' do
  Bundler.with_clean_env do
    result_yaml = File.expand_path('results/mjit_releases.yml', __dir__)
    bench_dir = File.expand_path('benchmarks/mjit-benchmarks/benchmarks', __dir__)
    sh "RESULT_YAML=#{result_yaml.shellescape} bin/benchmark-driver -o skybench #{bench_dir.shellescape}/aread.yml "\
      "--rbenv '#{release_rubies.join(';')}'"
  end
end

task default: :mjit_releases

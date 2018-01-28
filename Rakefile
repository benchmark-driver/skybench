task 'mjit-benchmarks' do
  sh 'git clone https://github.com/benchmark-driver/mjit-benchmarks'
end

desc 'Run MJIT benchmark'
task mjit: 'mjit-benchmarks' do
  Bundler.with_clean_env do
    sh 'bin/benchmark-driver -o skybench mjit-benchmarks/benchmarks/*.yml'
  end
end

task default: :mjit

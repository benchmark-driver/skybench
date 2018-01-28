desc 'Run MJIT benchmark'
task :mjit do
  Bundler.with_clean_env do
    sh 'bundle exec benchmark-driver'
  end
end

task default: :mjit

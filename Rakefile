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

names.each do |name|
  desc "Update #{name} releases"
  task :"#{name}_releases" do
    sh "echo hello"
    # Bundler.with_clean_env
    # RESULT_YAML=results/xxx.yml bin/benchmark-driver -o skybench --rbenv 'xxx;yyy' xxx.yml
  end
end

task default: names.map { |name| :"#{name}_releases" }

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc 'Run Steep type checking'
task :steep do
  sh 'bundle exec steep check'
end

task default: [:spec, :steep]

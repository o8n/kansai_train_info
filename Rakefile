require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

desc 'Run Steep type checking'
task :steep do
  sh 'bundle exec steep check'
end

task default: %i[spec rubocop steep]

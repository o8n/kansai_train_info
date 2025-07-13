require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/vendor/'

  minimum_coverage 90
  refuse_coverage_drop

  add_group 'Libraries', 'lib'
  add_group 'CLI', 'lib/kansai_train_info/cli'
  add_group 'Client', 'lib/kansai_train_info/client'
end

require 'bundler/setup'
require 'kansai_train_info'
require 'webmock/rspec'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

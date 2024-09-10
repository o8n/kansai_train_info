source "https://rubygems.org"

gemspec

gem "rake", "~> 12.3"
gem "rspec", "~> 3.0"

gem 'bundler'
gem 'pry'

gem 'rubocop', require: false

gem 'sorbet', :group => :development
gem 'sorbet-runtime'
gem 'tapioca', require: false, :group => [:development, :test]

group :test do
  gem 'simplecov', require: false
  gem 'webmock'
end

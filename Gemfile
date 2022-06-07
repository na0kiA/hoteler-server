source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "rails", "~> 7.0.2", ">= 7.0.2.4"

gem "sprockets-rails"
gem "mysql2", "~> 0.5"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "bcrypt"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false

gem 'rack-cors'
gem 'devise', '>= 4.8.1'
gem 'devise_token_auth', '>= 1.2.0', git: "https://github.com/lynndylanhurley/devise_token_auth"
gem 'rails_admin', '~> 3.0'

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'dotenv-rails'
  gem "factory_bot_rails"
  gem "rspec-rails"
end

group :development do
  gem "web-console"
  gem 'rubocop', require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem 'simplecov', require: false
  gem "webdrivers"
end
gem "sassc-rails"

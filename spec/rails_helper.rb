require 'spec_helper'
# require 'simplecov'
ENV['RAILS_ENV'] ||= 'test'
# SimpleCov.start
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include AuthorizationHelper, type: :request
end

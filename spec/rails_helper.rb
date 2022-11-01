# frozen_string_literal: true

require 'spec_helper'

require 'simplecov'
ENV['RAILS_ENV'] ||= 'test'
# require_relative '../config/environment'
require File.expand_path('../config/environment', __dir__)
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
require 'test_prof/recipes/rspec/let_it_be'
SimpleCov.start do
  enable_coverage :branch

  add_group 'Models', 'app/models'
  add_group 'Forms', 'app/forms'
  add_group 'Controllers (api)', 'app/controllers/v1'
  add_group 'Helpers', 'app/helpers'
end
require 'devise'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  # Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
  # Dir[Rails.root.join('spec/support/*.rb')].each { |f| require f }
  config.include FactoryBot::Syntax::Methods
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.raise_errors_for_deprecations!
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include CustomValidatorHelper, type: :model
  config.include RequestSpecHelper
  config.include HotelFormSpecHelper
  config.include RestRateSpecHelper
  config.include ActiveSupport::Testing::TimeHelpers
  # config.include Rails.application.routes.url_helpers
end

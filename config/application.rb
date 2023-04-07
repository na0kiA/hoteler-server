# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# require 'active_model_serializers'

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.api_only = true
    config.load_defaults 7.0
    config.time_zone = "Tokyo"
    config.i18n.default_locale = :ja
    config.active_record.default_timezone = :local
    config.i18n.load_path += Dir[Rails.root.join("config/locales/**/*.{rb,yml}").to_s]

    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Flash
    config.middleware.use Rack::MethodOverride

    config.middleware.use ActionDispatch::ContentSecurityPolicy::Middleware

    config.action_controller.forgery_protection_origin_check = false

    config.middleware.use ActionDispatch::Session::CookieStore, { key: "_app_session", domani: "api.hoteler.jp", same_site: :none, secure: true }

    config.action_controller.raise_on_open_redirects = false

    config.generators do |g|
      g.test_framework :rspec,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false
    end
  end
end

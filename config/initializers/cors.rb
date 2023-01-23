# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # origins "*"
    origins "http://localhost:3000"
    # origins "localhost:3000", "127.0.0.1:3001", "http://localhost:3000"

    resource "*",
             headers: :any,
             expose: %w[access-token expiry token-type uid client X-CSRF-Token],
             methods: %i[get post put patch delete options head],
             credentials: true
  end
end

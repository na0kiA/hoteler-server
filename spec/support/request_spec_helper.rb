# frozen_string_literal: true

module RequestSpecHelper
  def symbolized_body(response)
    JSON.parse(response.body, symbolize_names: true)
  end

  def sign_up(account)
    post v1_user_registration_path, params: {
      password: "password123",
      password_confirmation: "password123",
      email: "#{account}@example.com"
    }
  end
end

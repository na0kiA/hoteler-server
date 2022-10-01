# frozen_string_literal: true

module RequestSpecHelper
  def symbolized_body(response)
    JSON.parse(response.body, symbolize_names: true)
  end

  # def sign_up(account)
  #   post v1_auth_path, params: {
  #     password: 'test2525',
  #     password_confirmation: 'test2525',
  #     email: "#{account}@example.com"
  #   }
  # end

  # def login(account)
  #   post v1_auth_session_path, params: {
  #     email: "#{account}@example.com",
  #     password: 'test2525'
  #   }
  # end

  # def create_header_from_response(response)
  #   {
  #     uid: response.header['uid'],
  #     'access-token': response.header['access-token'],
  #     client: response.header['client']
  #   }
  # end

  # def get_current_user_by_response(response)
  #   User.find_by(uid: response.header['uid'])
  # end
end

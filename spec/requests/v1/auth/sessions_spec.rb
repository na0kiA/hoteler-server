# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "V1::Auth::SessionsController", type: :request do
  describe "describe POST /v1/auth/sign_in - v1/auth/sessions#create" do
    context 'サインインができる場合' do
      let_it_be(:client_user) { create(:user) }
      let_it_be(:auth_tokens) { client_user.create_new_auth_token }

      it '200を返すこと' do
        post v1_user_session_path, params: {
          email: client_user.email,
          password: client_user.password,
        }
        p response
        expect(response).to have_http_status(200)
      end
    end
  end
end

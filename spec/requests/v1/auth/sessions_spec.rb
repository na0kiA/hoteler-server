# frozen_string_literal: true

require "rails_helper"

RSpec.describe "V1::Auth::SessionsController", type: :request do
  describe "describe POST /v1/auth/sign_in - v1/auth/sessions#create" do
    context "メール認証をしていないアカウントの場合" do
      let_it_be(:client_user) { create(:user) }
      let_it_be(:auth_tokens) { client_user.create_new_auth_token }

      it "sign_in時に401エラーを返すこと" do
        post v1_user_session_path, params: {
          email: client_user.email,
          password: client_user.password
        }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end

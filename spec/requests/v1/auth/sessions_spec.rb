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
        expect(response.status).to eq(401)
      end
    end
  end

  describe "describe DELETE /v1/auth/sign_out - v1/auth/sessions#destroy" do
    context "サインアウトができる場合" do
      let_it_be(:client_user) { create(:user) }
      let_it_be(:auth_tokens) { client_user.create_new_auth_token }

      it "200を返すこと" do
        delete destroy_v1_user_session_path, headers: auth_tokens
        expect(response.status).to eq(200)
      end
    end

    context "サインアウトができない場合" do
      let_it_be(:client_user) { create(:user) }
      let_it_be(:auth_tokens) { client_user.create_new_auth_token }

      it "200を返すこと" do
        delete destroy_v1_user_session_path
        expect(response.status).to eq(404)
        expect(symbolized_body(response)[:errors][0]).to eq("ユーザーが見つからないか、ログインしていません。")
      end
    end
  end

  describe "describe GET /v1/auth/sessions - v1/auth/sessions#index" do
    context "ログインしている場合" do
      let_it_be(:client_user) { create(:user) }
      let_it_be(:auth_tokens) { client_user.create_new_auth_token }

      it "is_loginがtrueを返すこと" do
        get v1_auth_sessions_path, headers: auth_tokens
        expect(symbolized_body(response)[:is_login]).to be(true)
      end
    end

    context "ログインしていない場合" do
      it "is_loginがfalseを返すこと" do
        get v1_auth_sessions_path
        expect(symbolized_body(response)[:is_login]).to be(false)
      end
    end
  end
end

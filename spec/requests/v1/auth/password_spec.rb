# frozen_string_literal: true

require "rails_helper"

RSpec.describe "V1::Auth::Passwords", type: :request do
  describe "describe PATCH /v1/auth/password - v1/auth/password#update" do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:auth_tokens) { client_user.create_new_auth_token }

    context "パスワードの変更ができる場合" do
      it "200を返すこと" do
        params = { email: client_user.email, redirect_url: "http://localhost:3001/" }
        post v1_user_password_path, params:, headers: auth_tokens
        expect(response.status).to eq(200)
        expect(symbolized_body(response)[:message]).to eq("'#{client_user.email}' にパスワードリセットの案内が送信されました。")
      end
    end

    # context "emailの更新ができる場合" do
    #   it "200を返すこと" do
    #     params = { email: "test@example.com" }
    #     patch v1_user_registration_path, params: params, headers: auth_tokens
    #     expect(response.status).to eq(200)
    #   end
    # end
  end
end

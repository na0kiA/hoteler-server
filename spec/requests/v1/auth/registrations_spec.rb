# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "V1::Auth::Registrations", type: :request do
  describe "describe POST /v1/auth - v1/auth/registrations#create" do
    context 'ユーザー登録ができる場合' do
      it '200を返すこと' do
        params = {name: "渋谷太郎", email: "test12@example.com", password: "12345678", password_confirmation: "12345678", confirm_success_url: "http://example.com"}
        post v1_user_registration_path, params: params
        expect(response.status).to eq(200)
      end
    end
  end
end

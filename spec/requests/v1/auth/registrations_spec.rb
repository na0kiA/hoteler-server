# frozen_string_literal: true

require "rails_helper"

RSpec.describe "V1::Auth::Registrations", type: :request do
  describe "describe POST /v1/auth - v1/auth/registrations#create" do
    context "ユーザー登録ができる場合" do
      it "200を返すこと" do
        params = { name: "渋谷太郎", email: "test12@example.com", password: "12345678", password_confirmation: "12345678", confirm_success_url: "http://example.com" }
        post(v1_user_registration_path, params:)
        expect(response.status).to eq(200)
      end

      it "登録時にimageにデフォルトの画像のkeyがセットされていること" do
        params = { name: "渋谷太郎", email: "test12@example.com", password: "12345678", password_confirmation: "12345678", confirm_success_url: "http://example.com" }
        post(v1_user_registration_path, params:)
        expect(User.first.image).to include("hoteler")
      end
    end
  end

  describe "describe patch /v1/auth - v1/auth/registrations#update" do
    let_it_be(:auth_tokens) { create(:user).create_new_auth_token }

    context "ユーザー画像の更新ができる場合" do
      it "200を返すこと" do
        params = { image: "aws/s3/keys/" }
        patch v1_user_registration_path, params:, headers: auth_tokens
        expect(response.status).to eq(200)
      end
    end

    context "emailの更新ができる場合" do
      it "200を返すこと" do
        params = { email: "test@example.com" }
        patch v1_user_registration_path, params:, headers: auth_tokens
        expect(response.status).to eq(200)
      end
    end
  end

  describe "describe delete /v1/auth - v1/auth/registrations#destroy" do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:auth_tokens) { client_user.create_new_auth_token }

    context "ユーザーの削除ができる場合" do
      it "200を返すこと" do
        delete v1_user_registration_path, headers: auth_tokens
        expect(response.status).to eq(200)
      end
    end

    context "ユーザーが口コミのあるホテルを持っている場合" do
      let_it_be(:hotel) { create(:accepted_hotel, user: client_user) }
      let_it_be(:review) { create(:review, hotel:) }
      let_it_be(:notification) { create(:notification, hotel:, sender: review.user, user: client_user, message: review.title, kind: "came_reviews") }

      it "ユーザー削除時にホテルとその口コミと通知も削除されること" do
        expect {
          delete v1_user_registration_path, headers: auth_tokens
        }.to change(Hotel, :count).by(-1).and change(Notification, :count).by(-1).and change(Review, :count).by(-1)
        expect(response.status).to eq(200)
      end
    end

    context "ユーザーがホテルを持っている場合" do
      let_it_be(:hotel) { create(:completed_profile_hotel, user: client_user) }

      it "ユーザー削除時にホテルとdaysとhoetel_facilityが合わせて削除されること" do
        expect {
          delete v1_user_registration_path, headers: auth_tokens
        }.to change(Hotel, :count).by(-1).and change(Day, :count).by(-7).and change(HotelFacility, :count).by(-1)
      end
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe "V1::UserFavorites", type: :request do
  describe "GET /v1/users/:id/favorites - v1/user_favorites#index" do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:auth_tokens) { client_user.create_new_auth_token }
    let_it_be(:with_hotel_and_image_favorite_one) { create(:with_hotel_and_image_favorite, user_id: client_user.id) }
    let_it_be(:with_hotel_and_image_favorite_two) { create(:with_hotel_and_image_favorite, user_id: client_user.id) }

    context "ログインしていない場合" do
      it "お気に入り一覧を取得できないこと" do
        get v1_favorites_path(client_user.id)
        expect(response.status).to eq(401)
      end
    end

    context "ログインしている場合" do
      it "お気に入り一覧をIDの新しい順に取得できること" do
        get v1_favorites_path(client_user.id), headers: auth_tokens
        expect(response.status).to eq(200)
        expect(symbolized_body(response)[:favorites][0][:id]).to eq(with_hotel_and_image_favorite_two.id)
        expect(symbolized_body(response)[:favorites][1][:id]).to eq(with_hotel_and_image_favorite_one.id)
      end

      it "お気に入り一覧にホテル画像が含まれていること" do
        get v1_favorites_path(client_user.id), headers: auth_tokens
        expect(symbolized_body(response)[:favorites][0][:hotelTopImage][:id]).to eq(with_hotel_and_image_favorite_two.hotel.hotel_images.pick(:id))
      end
    end

    context "お気に入りのホテルの画像がない場合" do
      let_it_be(:not_found_image_hotel) { create(:accepted_hotel, :with_user) }
      let_it_be(:favorite) { create(:with_user_favorite, hotel_id: not_found_image_hotel.id) }

      it "未設定であることが表示されること" do
        get v1_favorites_path(favorite.user.id), headers: auth_tokens
        expect(response.status).to eq(200)
        expect(symbolized_body(response)[:favorites][0][:hotelTopImage]).to be_nil
      end
    end
  end
end

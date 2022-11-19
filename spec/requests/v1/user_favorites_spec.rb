require 'rails_helper'

RSpec.describe "V1::UserFavorites", type: :request do
  describe "GET /v1/users/:id/favorites - v1/user_favorites#index" do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:auth_tokens) { client_user.create_new_auth_token }
    let_it_be(:hotel_manager) { create(:user) }
    let_it_be(:hotel) { create(:accepted_hotel, user_id: hotel_manager.id)}
    let_it_be(:hotel_image) { create_list(:hotel_image, 2, hotel_id: hotel.id)}

    context 'ログインしていない場合' do
      it 'お気に入り一覧を取得できないこと' do
        get v1_favorites_path(client_user.id)
        expect(response.status).to eq(401)
      end
    end

    context 'ログインしている場合' do
      let_it_be(:first_favorite) { create(:favorite, user_id: client_user.id, hotel_id: create(:accepted_hotel, user_id: create(:user).id).id) }
      let_it_be(:second_favorite) { create(:favorite, user_id: client_user.id, hotel_id: create(:accepted_hotel, user_id: create(:user).id).id) }
      let_it_be(:first_hotel_image) { create_list(:hotel_image, 2, hotel_id: first_favorite.hotel_id)}
      let_it_be(:second_hotel_image) { create_list(:hotel_image, 2, hotel_id: second_favorite.hotel_id)}

      it 'お気に入り一覧をIDの新しい順に取得できること' do
        get v1_favorites_path(client_user.id), headers: auth_tokens
        expect(response.status).to eq(200)
        expect(symbolized_body(response)[0][:hotel_top_image][:id]).to eq(second_hotel_image.pick(:id))
        expect(symbolized_body(response)[0][:id]).to eq(second_favorite.id)
      end
    end

    context 'お気に入りのホテルの画像がない場合' do
      let_it_be(:favorite) { create(:favorite, user_id: client_user.id, hotel_id: create(:accepted_hotel, user_id: create(:user).id).id) }

      it '未設定であることが表示されること' do
        get v1_favorites_path(client_user.id), headers: auth_tokens
        expect(response.status).to eq(200)
        expect(symbolized_body(response)[0][:hotel_top_image]).to eq("ホテルの画像は未設定です")
      end
    end
  end
end

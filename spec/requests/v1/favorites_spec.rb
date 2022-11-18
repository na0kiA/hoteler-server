# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Favorites', type: :request do
  describe 'POST /v1/hotels/:hotel_id/favorites - v1/favorites#create' do
    let_it_be(:client_user)  { create(:user) }
    let_it_be(:auth_tokens)  { client_user.create_new_auth_token }
    let_it_be(:hotel_manager)  { create(:user) }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: hotel_manager.id) }

    context 'お気に入りのホテルを登録できる場合' do
      it '200を返してfavoritesテーブルに新しく保存されていること' do
        expect {
          post v1_hotel_favorites_path(accepted_hotel.id), headers: auth_tokens
        }.to change(Favorite, :count).by(1)
        expect(response.status).to eq(200)
      end
    end

    context 'ログインしていない場合' do
      it '401が返ること' do
        post v1_hotel_favorites_path(accepted_hotel.id), headers: nil
        expect(response.status).to eq(401)
      end
    end

    context 'ホテルが存在しない場合' do
      it '404が返ること' do
        post v1_hotel_favorites_path(0), headers: auth_tokens
        expect(response.status).to eq(400)
      end
    end

    context '未承認の自分のホテルをお気に入りに追加しようとした場合' do
      let_it_be(:hidden_hotel) { create(:hotel, user_id: client_user.id) }

      it '400が返ること' do
        post v1_hotel_favorites_path(hidden_hotel), headers: auth_tokens
        expect(response.status).to eq(400)
        expect(symbolized_body(response)[:errors][:body]).to eq('自分のホテルはお気に入りに登録できません。')
      end
    end

    context 'お気に入りを既に登録している場合' do
      it 'destroyアクションに内部リダイレクトされること' do
        expect { post v1_hotel_favorites_path(accepted_hotel.id), headers: auth_tokens }.to change(Favorite, :count).by(1)
        post v1_hotel_favorites_path(accepted_hotel.id), headers: auth_tokens
        expect(response.status).to eq(302)
      end
    end
  end

  describe 'delete /v1/hotels/:hotel_id/favorites/:id - v1/favorites#destroy' do
    let_it_be(:client_user)  { create(:user) }
    let_it_be(:auth_tokens)  { client_user.create_new_auth_token }
    let_it_be(:hotel_manager)  { create(:user) }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: hotel_manager.id) }

    context 'ログインをしていないのに削除しようとした場合' do
      let_it_be(:favorite) { create(:favorite, hotel_id: accepted_hotel.id, user_id: client_user.id) }

      it '401が返ること' do
        expect { delete v1_hotel_favorites_path(accepted_hotel.id), headers: nil }.not_to change(Favorite, :count)
        expect(response.status).to eq(401)
      end
    end

    context '存在しないホテルのお気に入りを消そうとした場合' do
      let_it_be(:hotel_manager_auth_tokens) { hotel_manager.create_new_auth_token }
      let_it_be(:favorite) { create(:favorite, hotel_id: accepted_hotel.id, user_id: client_user.id) }

      before do
        delete v1_hotel_path(accepted_hotel.id), headers: hotel_manager_auth_tokens
      end

      it '400が返ること' do
        delete v1_hotel_favorites_path(accepted_hotel), headers: auth_tokens
        expect(response.status).to eq(400)
      end
    end

    context '未承認の自分のホテルのお気に入りを削除しようとした場合' do
      let_it_be(:hidden_hotel) { create(:hotel, user_id: client_user.id) }
      let_it_be(:favorite) { create(:favorite, hotel_id: hidden_hotel.id, user_id: client_user.id) }

      it '400が返ること' do
        delete v1_hotel_favorites_path(hidden_hotel.id), headers: auth_tokens
        expect(response.status).to eq(400)
      end
    end

    context 'お気に入りに登録してあるuser_idとcurrent_usetが違う場合' do
      let_it_be(:other_user) { create(:user) }
      let_it_be(:other_user_auth_tokens) { other_user.create_new_auth_token }

      before do
        post v1_hotel_favorites_path(accepted_hotel.id), headers: auth_tokens
      end

      it '400が返ること' do
        expect { delete v1_hotel_favorites_path(accepted_hotel.id), headers: other_user_auth_tokens }.not_to change(Favorite, :count)
        expect(response.status).to eq(400)
      end
    end

    context 'お気に入りを解除できる場合' do
      let_it_be(:favorite) { create(:favorite, hotel_id: accepted_hotel.id, user_id: client_user.id) }

      it '200が返ること' do
        delete v1_hotel_favorites_path(accepted_hotel.id), headers: auth_tokens
        expect(response.status).to eq(200)
      end
    end
  end
end

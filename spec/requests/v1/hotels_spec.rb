require 'rails_helper'

RSpec.describe 'V1::Hotels', type: :request do
  describe 'POST /v1/hotels - v1/hotels#create' do
    let_it_be(:client_user)  { create(:user) }
    let_it_be(:auth_tokens)  { client_user.create_new_auth_token }

    context 'ログインしている場合' do
      it 'ホテルの投稿ができること' do
        params = { hotel: { name: 'hotelName', content: 'Kobe Kitanosaka is location', key: ['upload/test'] } }
        expect do
          post v1_hotels_path, params:, headers: auth_tokens
        end.to change(Hotel.all, :count).by(1)
        expect(response).to have_http_status :ok
      end
    end

    context 'ログインしていない場合' do
      it 'ホテルの投稿ができないこと' do
        params = { hotel: { name: 'hotelName', content: 'hotelContent', key: ['upload/test'] } }
        post v1_hotels_path, params: params, headers: nil
        expect(response).to have_http_status(:unauthorized)
        expect(response.message).to include('Unauthorized')
      end
    end

    context 'ホテルの投稿ができない場合' do
      it '400を返すこと' do
        params = { hotel: { name: '', content: 'hotelContent', key: ['upload/test'] } }
        post v1_hotels_path, params: params, headers: auth_tokens
        expect(response).to have_http_status(:bad_request)
        expect(response.message).to include('Bad Request')
      end
    end
  end

  describe 'PATCH /v1/hotel - v1/hotels#update' do
    let_it_be(:client_user)  { create(:user) }
    let_it_be(:auth_tokens)  { client_user.create_new_auth_token }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: client_user.id) }

    context 'ログインしている場合' do
      it '自分の投稿したホテルの編集ができること' do
        params = { hotel: { name: 'hotel 777', content: 'hotel has been updated', key: ['upload/test', 'upload/test2'] } }
        patch v1_hotel_path(accepted_hotel.id), params: params, headers: auth_tokens
        expect(response).to have_http_status :ok
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body[:attributes]).to include(name: 'hotel 777', content: 'hotel has been updated')
      end

      it '自分が投稿していないホテルの編集ができないこと' do
        user = create(:user)
        hotel = create(:accepted_hotel, user_id: user.id)
        params = { hotel: { name: 'hotel 777', content: 'hotel has been updated!', key: ['upload/test', 'upload/test2'] } }
        patch v1_hotel_path(hotel.id), params: params, headers: auth_tokens
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body).not_to include(name: 'hotel 7777', content: 'hotel has been updated!')
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'ログインしていない場合' do
      it 'ホテルの編集ができないこと' do
        params = { hotel: { name: 'hotel 77777', content: 'hotel has been updated!!' } }
        patch v1_hotel_path(accepted_hotel.id), params: params
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:unauthorized)
        expect(response_body).not_to include(name: 'hotel 77777', content: 'hotel has been updated!!')
      end
    end
  end

  describe 'DELETE /v1/hotels - v1/hotels#destroy' do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:auth_tokens) { client_user.create_new_auth_token }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: client_user.id) }

    context 'ログインしている場合' do
      it 'ユーザーが投稿したホテルを削除できること' do
        expect do
          delete v1_hotel_path(accepted_hotel.id), headers: auth_tokens
        end.to change(Hotel, :count).by(-1)
        expect(response).to have_http_status :ok
      end

      it '自分が投稿していないホテルを削除できないこと' do
        user = create(:user)
        hotel = create(:accepted_hotel, user_id: user.id)
        expect do
          delete v1_hotel_path(hotel.id), headers: auth_tokens
        end.not_to change(Hotel, :count)
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'ログインしていない場合' do
      it 'ユーザーが投稿したホテルを削除できないこと' do
        expect do
          delete v1_hotel_path(accepted_hotel.id), headers: nil
        end.not_to change(Hotel, :count)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /v1/hotels - v1/hotels#index' do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:hidden_hotel) { create(:hotel, user_id: client_user.id) }
    let_it_be(:auth_tokens) { client_user.create_new_auth_token }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: client_user.id) }

    context 'ホテルが承認されている場合' do
      it 'ホテル一覧を取得できること' do
        get v1_hotels_path
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:success)
        expect(response_body[0][:accepted]).to be true
        expect(response_body.length).to eq 1
      end
    end

    context 'ホテルが承認されていない場合' do
      it 'ホテル一覧を取得できないこと' do
        get v1_hotels_path
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body.length).not_to eq 2
      end
    end
  end

  describe 'GET /v1/hotel/:id - v1/hotels#show' do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:hidden_hotel) { create(:hotel, user_id: client_user.id) }
    let_it_be(:auth_tokens) { client_user.create_new_auth_token }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: client_user.id) }

    context 'ホテルが承認されている場合' do
      it 'ホテル詳細を取得できること' do
        get v1_hotel_path(accepted_hotel.id)
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:success)
        expect(response_body[:accepted]).to be true
        expect(response_body.length).to eq 7
      end
    end

    context 'ホテルが承認されていない場合' do
      it 'ホテル詳細を取得できないこと' do
        get v1_hotel_path(hidden_hotel.id)
        expect(response).to have_http_status(:not_found)
      end
    end

    context '存在しないホテルを取得しようとした場合' do
      it '404 NOT FOUND を返すこと' do
        get v1_hotel_path(10**5)
        expect(response).to have_http_status(:not_found)
        expect(response.message).to eq('Not Found')
      end
    end
  end
end

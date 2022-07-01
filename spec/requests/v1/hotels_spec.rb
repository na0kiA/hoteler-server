require 'rails_helper'

RSpec.describe "V1::Hotels", type: :request do
  describe "POST /v1/hotels - v1/hotels#create" do
    let_it_be(:client_user)  { create(:user) }
    let_it_be(:auth_tokens)  { client_user.create_new_auth_token }

    context "ログインしている場合" do
      it "ホテルの投稿ができること" do
        params = { hotel: { name: "hotelName", content: "hotelContent" } }
        expect do
          post v1_hotels_path, params: params, headers: auth_tokens
        end.to change(Hotel.all, :count).by(1)
        expect(response).to have_http_status :ok
      end

      it "nameとcontentが空なら投稿ができないこと" do
        hotel_empty = { hotel: { name: nil, content: nil } }
        expect do
          post v1_hotels_path, params: hotel_empty, headers: auth_tokens
        end.not_to change(Hotel, :count)
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "ログインしていない場合" do
      it "ホテルの投稿ができないこと" do
        params = { name: "hotelName", content: "hotelContent" }
        post v1_hotels_path, params: params, headers: nil
        expect(response).to have_http_status(:unauthorized)
        expect(response.message).to include('Unauthorized')
      end
    end
  end

  describe "PUT /v1/hotels - v1/hotels#update" do
    let_it_be(:client_user)  { create(:user) }
    let_it_be(:auth_tokens)  { client_user.create_new_auth_token }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: client_user.id) }

    context "ログインしている場合" do
      it "自分の投稿したホテルの編集ができること" do
        put v1_hotel_path(accepted_hotel.id), params: update_params, headers: auth_tokens
        expect(response).to have_http_status :ok
        expect(Hotel.find(accepted_hotel.id)).to include(update_params)
      end
      it "自分が投稿していないホテルの編集ができないこと" do
        update_params = { hotel: { name: "hotel 777", content: "hotel has been updated"} }
          put v1_hotel_1_path, params: update_params, headers: auth_tokens
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "ログインしていない場合" do
      it "ホテルの編集ができないこと" do
        put v1_hotel_path(accepted_hotel.id), params: update_params
        expect(response).to have_http_status :ok
        expect(Hotel.find(accepted_hotel.id)).to include(update_params)
      end
    end
  end

  describe "DELETE /v1/hotels - v1/hotels#destroy" do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:auth_tokens) { client_user.create_new_auth_token }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: client_user.id) }

    context "ログインしている場合" do
      it "ユーザーが投稿したホテルを削除できること" do
        expect do
          delete v1_hotel_path(accepted_hotel.id), headers: auth_tokens
        end.to change(Hotel, :count).by(-1)
        expect(response).to have_http_status :ok
      end
    end

    context "ログインしていない場合" do
      it "ユーザーが投稿したホテルを削除できないこと" do
        expect do
          delete "/v1/hotels/#{accepted_hotel.id}", headers: nil
        end.not_to change(Hotel, :count)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /v1/hotels - v1/hotels#index" do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:hidden_hotel) { create(:hotel, user_id: client_user.id) }
    let_it_be(:auth_tokens) { client_user.create_new_auth_token }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: client_user.id) }

    context "ホテルが承認されている場合" do
      it "ホテル一覧を取得できること" do
        get v1_hotels_path
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:success)
        expect(response_body[0][:accepted]).to be true
        expect(response_body.length).to eq 1
      end
    end

    context "ホテルが承認されていない場合" do
      it "ホテル一覧を取得できないこと" do
        get v1_hotels_path
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body.length).not_to eq 2
      end
    end
  end

  describe "GET /v1/hotels/:id - v1/hotels#show" do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:hidden_hotel) { create(:hotel, user_id: client_user.id) }
    let_it_be(:auth_tokens) { client_user.create_new_auth_token }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: client_user.id) }

    context "ホテルが承認されている場合" do
      it "ホテル詳細を取得できること" do
        get v1_hotel_path(accepted_hotel.id)
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:success)
        expect(response_body[:accepted]).to be true
        expect(response_body.length).to eq 8
      end
    end

    context "ホテルが承認されていない場合" do
      it "ホテル詳細を取得できないこと" do
        get v1_hotel_path(hidden_hotel.id)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end

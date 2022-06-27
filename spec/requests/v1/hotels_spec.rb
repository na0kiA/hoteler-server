require 'rails_helper'

RSpec.describe "V1::Hotels", type: :request do
  describe "POST /v1/hotels - v1/hotels#create" do
    let!(:client_user)  { create(:user) }
    let!(:auth_tokens)  { client_user.create_new_auth_token }

    context "ログインしている場合" do
      it "POSTができること" do
        params = { name: "hotelName", content: "hotelContent" }
        expect do
          post v1_hotels_path, params:, headers: auth_tokens
        end.to change(Hotel.all, :count).by(1)
        expect(response).to have_http_status :ok
      end

      it "nameとcontentが空ならPOSTができないこと" do
        hotel_empty = { name: nil, content: nil }
        expect do
          post v1_hotels_path, params: hotel_empty, headers: auth_tokens
        end.not_to change(Hotel, :count)
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "ログインしていない場合" do
      it "POSTができないこと" do
        params = { name: "hotelName", content: "hotelContent" }
        post v1_hotels_path, params: params, headers: nil
        expect(response).to have_http_status(:unauthorized)
        expect(response.message).to include('Unauthorized')
      end
    end
  end

  describe "DELETE /v1/hotels - v1/hotels#destroy" do
    let!(:client_user) { create(:user) }
    let!(:client_user_hotel) { create(:hotel, user_id: client_user.id) }
    let!(:auth_tokens) { client_user.create_new_auth_token }

    context "ログインしている場合" do
      it "userが投稿したhotelsをDELETEできること" do
        expect do
          delete "/v1/hotels/#{client_user_hotel.id}", headers: auth_tokens
        end.to change(Hotel, :count).by(-1)
        expect(response).to have_http_status :ok
      end
    end

    context "ログインしていない場合" do
      it "userが投稿したhotelsをDELETEできないこと" do
        expect do
          delete "/v1/hotels/#{client_user_hotel.id}", headers: nil
        end.not_to change(Hotel, :count)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /v1/hotels - v1/hotels#index" do
    let!(:client_user) { create(:user) }
    let!(:client_user_hotel) { create(:hotel, user_id: client_user.id) }
    let!(:auth_tokens) { client_user.create_new_auth_token }
    let!(:accepted_hotel){create(:hotel_accepted, user_id: client_user.id)}

    let!(:params) do
       { name: "Hotel", content: "Hotel"}
    end

    before do
      post v1_hotels_path, params: params, headers: auth_tokens
      # post v1_hotels_path, params: accepted_hotel, headers: auth_tokens
    end

    context "ホテルのacceptedカラムがtrueのとき" do
      it "acceptedカラムがtrueのホテル一覧を取得できること" do
        # hotel = Hotel.create(name: "Hotel", content: "Hotel", accepted: true, user_id: client_user.id)
        get v1_hotels_path
        # response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response.body).to eq(accepted_hotel)
      end
    end
    # context "ホテルのacceptedカラムがfalseのとき" do
    #   it "acceptedカラムがfalseのホテルを取得できないこと" do
    #     get v1_hotels_path
    #     response_body = JSON.parse(response.body, symbolize_names: true)
    #     expect(response_body).to eq([])
    #   end
    # end
  end
end

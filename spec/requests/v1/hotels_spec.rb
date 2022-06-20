require 'rails_helper'

RSpec.describe "V1::Hotels", type: :request do
  describe "POST /v1/hotels - v1/hotels#create" do
    let!(:client_user)  { create(:user) }
    let!(:auth_tokens)  { client_user.create_new_auth_token }

    context "ログインしている場合" do
      it "POSTができること" do
        params = { name: "hotelName", content: "hotelContent"}
        expect do 
          post v1_hotels_path, params: params, headers: auth_tokens
        end.to change(Hotel.all, :count).by(1)
        expect(response).to have_http_status :ok
      end
      it "nameとcontentが空ならPOSTができないこと" do
        hotel_empty = {name: nil, content: nil}
        expect do 
          post v1_hotels_path, params: hotel_empty, headers: auth_tokens
        end.to change(Hotel, :count).by(0)
        expect(response).to have_http_status(400)
      end
    end

    context "ログインしていない場合" do
      it "POSTができないこと" do
        params = { name: "hotelName", content: "hotelContent"}
        post v1_hotels_path, params: params, headers: nil
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end
  end

  describe "DELETE /v1/hotels - v1/hotels#destroy" do
    let!(:client_user)  { create(:user) }
    let!(:client_user_hotel)  { create(:hotel, user_id: client_user.id) }
    let!(:auth_tokens)  { client_user.create_new_auth_token }

    context "DELETEできる場合" do
      it "userが投稿したhotelsをDELETEできること" do
        expect do
          delete "/v1" + "/hotels/" + client_user_hotel.id.to_s, headers: auth_tokens
        end.to change {Hotel.count}.by(-1)
        expect(response).to have_http_status :ok
      end
    end

    context "DELETEできない場合" do
      it "userが投稿したhotelsをDELETEできないこと" do
        expect do
          delete "/v1" + "/hotels/" + client_user_hotel.id.to_s, headers: nil
        end.to change {Hotel.count}.by(0)
        expect(response).to have_http_status(401)
      end
    end
  end







end
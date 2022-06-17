require 'rails_helper'

RSpec.describe "V1::Hotels", type: :request do
  describe "POST /create" do
    let!(:client_user)  { create(:user) }
    let!(:auth_tokens)  { client_user.create_new_auth_token }
    let!(:hotel)  { client_user.hotels.create(name: "hotelName", content: "hotelContent") }

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
        # expect(response).to have_http_status(400)
      end
    end

    context "ログインしていない場合" do
      it "POSTができないこと" do
        params = build(:hotel)
        post v1_hotels_path, params: {hotel: params}
        expect(response).to have_http_status(401)
        expect(response.message).to include('Unauthorized')
      end
    end
  end
end
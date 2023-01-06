# frozen_string_literal: true

require "rails_helper"

RSpec.describe "V1::HotelFacilities", type: :request do
  describe "PATCH /v1/hotels/:hotel_id/hotel_facilities - v1/hotel_facilities #update" do
    context "ホテルの設備を更新する場合" do
      let_it_be(:client_user) { create(:user) }
      let_it_be(:auth_tokens) { client_user.create_new_auth_token }
      let_it_be(:hotel) { create(:hotel, user: client_user) }

      it "wifiを利用可能にできること" do
        patch v1_hotel_hotel_facilities_path(hotel.id), params: { hotel_facilities: { wifi_enabled: true } }, headers: auth_tokens
        expect(symbolized_body(response)[:hotelFacilities][:wifiEnabled]).to eq("Wi-Fiあり")
      end

      it "全ての設備を利用可能にできること" do
        patch v1_hotel_hotel_facilities_path(hotel.id),
              params: { hotel_facilities: { wifi_enabled: true, parking_enabled: true, triple_rooms_enabled: true, secret_payment_enabled: true, credit_card_enabled: true, phone_reservation_enabled: true, net_reservation_enabled: true, cooking_enabled: true, breakfast_enabled: true } }, headers: auth_tokens
        expect(symbolized_body(response)[:hotelFacilities][:breakfastEnabled]).to eq("朝食あり")
      end
    end
  end
end

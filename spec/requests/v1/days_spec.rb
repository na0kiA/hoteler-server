# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Days', type: :request do
  describe 'GET /v1/hotel/:hotel_id/days - v1/hotel/:hotel_id/days#index' do
    let_it_be(:client_user)  { create(:user) }
    let_it_be(:auth_tokens)  { client_user.create_new_auth_token }
    let_it_be(:hotel) { create(:completed_profile_hotel, :with_days, user_id: client_user.id) }

    context 'ホテルが作成されている場合' do
      it 'ホテルの曜日を返すこと' do
        get v1_hotel_days_path(hotel_id: hotel.id)
        expect(response.status).to eq(200)
        expect(symbolized_body(response).length).to eq(8)
      end
    end

    context 'ホテルが存在しない場合' do
      before do
        delete v1_hotel_path(hotel.id), headers: auth_tokens
      end

      it 'ホテルの曜日を返すこと' do
        get v1_hotel_days_path(hotel_id: hotel.id)
        expect(response.status).to eq(404)
      end
    end
  end
end

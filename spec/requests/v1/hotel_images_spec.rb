# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::HotelImages', type: :request do
  describe 'POST /v1/hotel/:hotel_id/images - v1/hotel/:hotel_id/images#create' do
    let_it_be(:client_user)  { create(:user) }
    let_it_be(:auth_tokens)  { client_user.create_new_auth_token }
    let_it_be(:hotel)  { create(:accepted_hotel, user_id: client_user.id) }
    let_it_be(:params)  { { hotel_image: { key: %w[key1998 key1998], hotel_id: hotel.id} }}

    context 'ログインしている場合' do
      it 'ホテルの画像投稿ができること' do
        expect do
          post v1_hotel_images_path(hotel.id), params:, headers: auth_tokens
        end.to change(HotelImage.all, :count).by(2)
        expect(response).to have_http_status :ok
      end
    end

    # context 'ログインしていない場合' do
    #   it 'ホテルの画像投稿ができないこと' do
    #     post v1_hotel_images_path, params:, headers: nil
    #     expect(response).to have_http_status(:unauthorized)
    #     expect(response.message).to include('Unauthorized')
    #   end
    # end

    # context 'S3のkeyがない場合' do
    #   it '400を返すこと' do
    #     params = { hotel_image: {key: []} }
    #     post v1_hotel_images_path, params: params, headers: auth_tokens
    #     expect(response).to have_http_status(:bad_request)
    #     expect(response.message).to include('Bad Request')
    #   end
    # end

  end
end

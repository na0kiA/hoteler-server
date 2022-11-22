# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Notifications', type: :request do
  describe 'GET /v1/index - v1/notifications #index' do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:auth_tokens) { client_user.create_new_auth_token }

    context '通知一覧を取得できる場合' do
      let_it_be(:accepted_hotel) { create(:with_user_completed_hotel) }
      let_it_be(:hotel_auth_tokens) { accepted_hotel.user.create_new_auth_token }
      let_it_be(:favorite) { create(:favorite, hotel: accepted_hotel, user: client_user) }
      let_it_be(:update_params) { { hotel: { name: '神戸北野', content: '最高峰のラグジュアリーホテルをお届けします', user_id: client_user }, message: '新しいソファーを設置しました。' } }

      before do
        patch v1_hotel_path(accepted_hotel.id), params: update_params, headers: hotel_auth_tokens
      end

      it 'お気に入りに登録したホテルの更新の通知を受け取ること' do
        get v1_notifications_path, headers: auth_tokens
        expect(symbolized_body(response)[0][:message]).to eq('新しいソファーを設置しました。')
        expect(symbolized_body(response)[0][:title]).to eq('神戸北野')
      end

      it '通知を新しい順に受け取ること' do
        notification = create(:notification, :with_hotel_updates, user: client_user, sender: accepted_hotel.user, hotel: accepted_hotel)
        get v1_notifications_path, headers: auth_tokens
        expect(symbolized_body(response).length).to eq(2)
        expect(symbolized_body(response)[0][:message]).to eq(notification.message)
      end
    end

    context 'お気に入りに登録していないホテルが更新された場合' do
      let_it_be(:accepted_hotel) { create(:with_user_completed_hotel) }
      let_it_be(:hotel_auth_tokens) { accepted_hotel.user.create_new_auth_token }
      let_it_be(:update_params) { { hotel: { name: '神戸北野', content: '最高峰のラグジュアリーホテルをお届けします', user_id: client_user }, message: '新しいソファーを設置しました。' } }
      let_it_be(:favorites) { create(:with_hotel_favorite, user: client_user) }

      before do
        patch v1_hotel_path(accepted_hotel.id), params: update_params, headers: hotel_auth_tokens
      end

      it '通知を受け取らないこと' do
        get v1_notifications_path, headers: auth_tokens
        expect(response.status).to eq(200)
        expect(symbolized_body(response)[:title]).to eq('まだ通知はありません。')
      end
    end

    context 'ホテルに口コミが書かれた場合' do
      # let_it_be(:accepted_hotel) { create(:with_user_completed_hotel) }
      # let_it_be(:hotel_auth_tokens) { accepted_hotel.user.create_new_auth_token }
      # let_it_be(:update_params) { { hotel: { name: '神戸北野', content: '最高峰のラグジュアリーホテルをお届けします', user_id: client_user }, message: '新しいソファーを設置しました。' } }
      # let_it_be(:favorites) { create(:with_hotel_favorite, user: client_user) }

      # before do
      #   patch v1_hotel_path(accepted_hotel.id), params: update_params, headers: hotel_auth_tokens
      # end

      it 'ホテル運営者は口コミの通知を受け取ること' do
        # get v1_notifications_path, headers: auth_tokens
        # expect(response.status).to eq(200)
        # expect(symbolized_body(response)[:title]).to eq('まだ通知はありません。')
      end
    end
  end
end

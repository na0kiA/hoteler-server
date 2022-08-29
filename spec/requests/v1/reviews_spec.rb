# このspecではitに期待値のみをコメント
# 所感 : 期待値のみをitに記述するより文脈を記述した方が分かりやすい
require 'rails_helper'

RSpec.describe 'V1::Reviews', type: :request do
  describe 'POST /v1/hotels/:hotel_id/reviews - v1/reviews#create' do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:auth_tokens) { client_user.create_new_auth_token }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: client_user.id) }
    let_it_be(:hotel) { create(:hotel, user_id: client_user.id) }
    let_it_be(:params) { { review: { title: 'hotelName', content: 'Kobe Kitanosaka is location', five_star_rate: 5 } } }

    context 'ログインしていて口コミの投稿ができる場合' do
      it '200を返すこと' do
        post v1_hotel_reviews_path(hotel_id: accepted_hotel.id), params: params, headers: auth_tokens
        expect(response.status).to eq(200)
        expect(symbolized_body(response).length).to eq(8)
        expect(symbolized_body(response)).to include(title: 'hotelName', content: 'Kobe Kitanosaka is location')
      end
    end

    context 'ログインしていてtitleの値が不正な場合' do
      it '400を返すこと' do
        params = { review: { title: '', content: 'Kobe Kitanosaka is location', five_star_rate: 5 } }
        post v1_hotel_reviews_path(hotel_id: accepted_hotel.id), params: params, headers: auth_tokens
        expect(response.status).to eq(400)
      end
    end

    context '未承認のホテルへの口コミ投稿をする場合' do
      it '404 NOT FOUNDを返すこと' do
        post v1_hotel_reviews_path(hotel_id: hotel.id), params: params, headers: auth_tokens
        expect(symbolized_body(response)).not_to include(title: 'hotelName')
        expect(response.status).to eq(404)
      end
    end

    context '星評価をしていない場合' do
      it '400を返すこと' do
        params = { review: { title: 'hotelName', content: 'Kobe Kitanosaka is location', five_star_rate: 0 } }
        post v1_hotel_reviews_path(hotel_id: accepted_hotel.id), params: params, headers: auth_tokens
        expect(response.status).to eq(400)
        expect(symbolized_body(response)).not_to include(title: 'hotelName', content: 'Kobe Kitanosaka is location')
      end
    end

    context 'ログインをしていない場合' do
      it '401を返すこと' do
        post v1_hotel_reviews_path(hotel_id: accepted_hotel.id), params: params, headers: nil
        expect(response).to have_http_status(:unauthorized)
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'GET /v1/hotels/:hotel_id/reviews - v1/reviews#index' do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:auth_tokens) { client_user.create_new_auth_token }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: client_user.id) }

    context '口コミ自体が存在するホテルに書かれている場合' do
      it 'okを返すこと' do
        create(:review, user_id: client_user.id, hotel_id: accepted_hotel.id)
        get v1_hotel_reviews_path(hotel_id: accepted_hotel.id)
        expect(response.status).to eq(200)
        expect(symbolized_body(response).length).to eq(1)
      end
    end

    context 'ホテルそのものが存在しない場合' do
      it '404 NOT FOUNDを返すこと' do
        unknow_hotel = create(:accepted_hotel, user_id: client_user.id)
        delete v1_hotel_path(id: unknow_hotel.id), headers: auth_tokens
        get v1_hotel_reviews_path(hotel_id: unknow_hotel.id)
        expect(symbolized_body(response).length).to eq(1)
        expect(response.status).to eq(404)
      end
    end
  end

  describe 'DELETE /v1/review/:id - v1/reviews#destroy' do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:auth_tokens) { client_user.create_new_auth_token }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: client_user.id) }
    let_it_be(:review) { create(:review, user_id: client_user.id, hotel_id: accepted_hotel.id) }

    context '口コミを削除できる場合' do
      it '200を返すこと' do
        expect do
          delete v1_user_review_path(id: review.id), headers: auth_tokens
        end.to change(Review, :count).by(-1)
        expect(response.status).to eq(200)
      end
    end

    context '他人の口コミを削除する場合' do
      it '400を返すこと' do
        user = create(:user)
        other_review = create(:review, hotel_id: accepted_hotel.id, user_id: user.id)
        expect do
          delete v1_user_review_path(id: other_review.id), headers: auth_tokens
        end.not_to change(Review, :count)
        expect(response.status).to eq(400)
      end
    end

    context 'ログインしていない場合' do
      it '401を返すこと' do
        expect do
          delete v1_user_review_path(id: review.id), headers: nil
        end.not_to change(Review, :count)
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'PATCH /v1/user/review/:id - v1/reviews#update' do
    let_it_be(:client_user)  { create(:user) }
    let_it_be(:auth_tokens)  { client_user.create_new_auth_token }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: client_user.id) }
    let_it_be(:review) { create(:review, user_id: client_user.id, hotel_id: accepted_hotel.id) }
    let_it_be(:params) { { review: { title: 'title uploaded', content: 'content uploaded', five_star_rate: 5 } } }

    context '自分の投稿した口コミの編集ができる場合' do
      it '200を返すこと' do
        patch v1_user_review_path(id: review.id), params: params, headers: auth_tokens
        expect(response.status).to eq(200)
        expect(symbolized_body(response)).to include(title: 'title uploaded', content: 'content uploaded')
      end
    end

    context '五つ星の編集ができる場合' do
      it '200を返すこと' do
        params = { review: { title: '五つ星を変えました', content: '五つ星を変えました。よかったです', five_star_rate: 2 } }
        patch v1_user_review_path(id: review.id), params: params, headers: auth_tokens
        expect(response.status).to eq(200)
        expect(symbolized_body(response)[:five_star_rate]).to eq('2')
      end
    end

    context '自分が投稿していない口コミの編集ができない場合' do
      it '400を返すこと' do
        user = create(:user)
        different_review = create(:review, user_id: user.id, hotel_id: accepted_hotel.id)
        patch v1_user_review_path(id: different_review.id), params: params, headers: auth_tokens
        expect(symbolized_body(response)).not_to include(title: 'title uploaded', content: 'content uploaded')
        expect(response.status).to eq(400)
      end
    end

    context 'ログインしていない場合' do
      it '401を返すこと' do
        patch v1_user_review_path(id: review.id), params: params
        expect(response.status).to eq(401)
        expect(symbolized_body(response)).not_to include(title: 'title uploaded', content: 'content uploaded')
      end
    end
  end

  describe 'GET /v1/reviews/:id - v1/reviews#show' do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:auth_tokens) { client_user.create_new_auth_token }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: client_user.id) }

    context '口コミが書かれている場合' do
      it '200を返すこと' do
        review = create(:review, user_id: client_user.id, hotel_id: accepted_hotel.id)
        get v1_user_review_path(id: review.id)
        expect(response.status).to eq(200)
        expect(symbolized_body(response).length).to eq(8)
      end
    end

    context 'ホテルそのものが存在しない場合' do
      it 'NOT FOUNDを返すこと' do
        unknow_hotel = create(:accepted_hotel, user_id: client_user.id)
        review = create(:review, user_id: client_user.id, hotel_id: unknow_hotel.id)
        delete v1_hotel_path(id: unknow_hotel.id), headers: auth_tokens
        get v1_user_review_path(id: review.id)
        expect(symbolized_body(response).length).to eq(1)
        expect(response.status).to eq(404)
      end
    end

    context '口コミを消去している場合' do
      it '404 NOT FOUNDを返すこと' do
        hotel = create(:accepted_hotel, user_id: client_user.id)
        review = create(:review, user_id: client_user.id, hotel_id: hotel.id)
        delete v1_user_review_path(id: review.id), headers: auth_tokens
        get v1_user_review_path(id: review.id)
        expect(symbolized_body(response).length).to eq(1)
        expect(response.status).to eq(404)
      end
    end

    context '口コミが存在しない場合' do
      it '404 NOT FOUNDを返すこと' do
        get v1_user_review_path(' ')
        expect(response.status).to eq(404)
        expect(response.message).to include('Not Found')
      end
    end
  end
end

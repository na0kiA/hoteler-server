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
        expect(symbolized_body(response).length).to eq(3)
        expect(symbolized_body(response)[:attributes]).to include(title: 'hotelName', content: 'Kobe Kitanosaka is location')
      end
    end

    context '画像を付けて口コミの投稿ができる場合' do
      it '200を返すこと' do
        images_params = { review: { title: 'hotelName', content: 'Kobe Kitanosaka is location', five_star_rate: 5, key: ['upload/test']} }
        post v1_hotel_reviews_path(hotel_id: accepted_hotel.id), params: images_params, headers: auth_tokens
        expect(response.status).to eq(200)
        expect(symbolized_body(response).length).to eq(3)
        expect(symbolized_body(response)[:attributes][:key]).to include("[\"upload/test\"]")
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

    context '画像の含まれている口コミを取得できる場合' do
      images_params = { review: { title: 'お風呂が綺麗でした', content: 'また行きたいと思っています', five_star_rate: 5, key: ['upload/test']} }

      before do
        post v1_hotel_reviews_path(hotel_id: accepted_hotel.id), params: images_params, headers: auth_tokens
      end

      it '200を返すこと' do
        get v1_hotel_reviews_path(hotel_id: accepted_hotel.id)
        expect(response.status).to eq(200)
        expect(symbolized_body(response)[0][:review_images][0][:key]).to eq('upload/test')
      end
    end

    context 'ホテルそのものが存在しない場合' do
      it '404 NOT FOUNDを返すこと' do
        unknow_hotel = create(:accepted_hotel, user_id: client_user.id)
        delete v1_hotel_path(unknow_hotel.id), headers: auth_tokens
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
          delete v1_user_review_path(review.id), headers: auth_tokens
        end.to change(Review, :count).by(-1)
        expect(response.status).to eq(200)
      end
    end

    context '他人の口コミを削除する場合' do
      it '400を返すこと' do
        user = create(:user)
        other_review = create(:review, hotel_id: accepted_hotel.id, user_id: user.id)
        expect do
          delete v1_user_review_path(other_review.id), headers: auth_tokens
        end.not_to change(Review, :count)
        expect(response.status).to eq(400)
      end
    end

    context 'ログインしていない場合' do
      it '401を返すこと' do
        expect do
          delete v1_user_review_path(review.id), headers: nil
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
        patch v1_user_review_path(review.id), params: params, headers: auth_tokens
        expect(response.status).to eq(200)
        expect(symbolized_body(response)[:attributes]).to include(title: 'title uploaded', content: 'content uploaded')
      end
    end

    context '五つ星の編集ができる場合' do
      it '200を返すこと' do
        params = { review: { title: '五つ星を変えました', content: '五つ星を変えました。よかったです', five_star_rate: 2 } }
        patch v1_user_review_path(review.id), params: params, headers: auth_tokens
        expect(response.status).to eq(200)
        expect(symbolized_body(response).length).to eq(3)
      end
    end

    context '画像の追加編集ができる場合' do
      it '200を返すこと' do
        empty_images_params = { review: { title: 'hotelName', content: 'Kobe Kitanosaka is location', five_star_rate: 5, key: [],} }
        post v1_hotel_reviews_path(hotel_id: accepted_hotel.id), params: empty_images_params, headers: auth_tokens
        expect(response.status).to eq(200)

        added_images_params = { review: { title: 'hotelName', content: 'Kobe Kitanosaka is location', five_star_rate: 5, key: ['upload/test']} }
        patch v1_user_review_path(review.id), params: added_images_params, headers: auth_tokens
        expect(response.status).to eq(200)
        expect(symbolized_body(response)[:attributes][:key]).to eq("[\"upload/test\"]")
      end
    end

    context '既存の画像の削除ができる場合' do
      it '200を返すこと' do
        params = { review: { title: '画像を追加しました', content: '画像を追加しました。よかったです', five_star_rate: 2, key: ['upload/test']} }
        post v1_hotel_reviews_path(hotel_id: accepted_hotel.id), params: params, headers: auth_tokens
        expect(response.status).to eq(200)

        delete_images_params = { review: { title: '画像を削除しました', content: '画像を削除しました。', five_star_rate: 2 } }
        patch v1_user_review_path(review.id), params: delete_images_params, headers: auth_tokens
        expect(response.status).to eq(200)
        expect(symbolized_body(response)[:attributes][:title]).to eq('画像を削除しました')
        expect(symbolized_body(response)[:attributes][:file_url]).to be_nil
      end
    end

    context '自分が投稿していない口コミの編集ができない場合' do
      it '400を返すこと' do
        user = create(:user)
        different_review = create(:review, user_id: user.id, hotel_id: accepted_hotel.id)
        patch v1_user_review_path(different_review.id), params: params, headers: auth_tokens
        expect(symbolized_body(response)).not_to include(title: 'title uploaded', content: 'content uploaded')
        expect(response.status).to eq(400)
      end
    end

    context 'ログインしていない場合' do
      it '401を返すこと' do
        patch v1_user_review_path(review.id), params: params
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
        get v1_user_review_path(review.id)
        expect(response.status).to eq(200)
        expect(symbolized_body(response).length).to eq(10)
      end
    end

    context 'ホテルそのものが存在しない場合' do
      it 'NOT FOUNDを返すこと' do
        unknow_hotel = create(:accepted_hotel, user_id: client_user.id)
        review = create(:review, user_id: client_user.id, hotel_id: unknow_hotel.id)
        delete v1_hotel_path(unknow_hotel.id), headers: auth_tokens
        get v1_user_review_path(review.id)
        expect(symbolized_body(response).length).to eq(1)
        expect(response.status).to eq(404)
      end
    end

    context '口コミを消去している場合' do
      it '404 NOT FOUNDを返すこと' do
        hotel = create(:accepted_hotel, user_id: client_user.id)
        review = create(:review, user_id: client_user.id, hotel_id: hotel.id)
        delete v1_user_review_path(review.id), headers: auth_tokens
        get v1_user_review_path(review.id)
        expect(symbolized_body(response).length).to eq(1)
        expect(response.status).to eq(404)
      end
    end

    context '口コミが存在しない場合' do
      it '404 NOT FOUNDを返すこと' do
        get v1_user_review_path(10**5)
        expect(response).to have_http_status(:not_found)
        expect(response.message).to eq('Not Found')
      end
    end
  end
end

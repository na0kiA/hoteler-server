require 'rails_helper'

RSpec.describe "V1::Reviews", type: :request do
  describe "POST /v1/hotels/:hotel_id/reviews - v1/reviews#create" do
    let_it_be(:client_user)  { create(:user) }
    let_it_be(:auth_tokens)  { client_user.create_new_auth_token }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: client_user.id) }
    let_it_be(:hotel) { create(:hotel, user_id: client_user.id) }
    let_it_be(:params) {  { review: { title: "hotelName", content: "Kobe Kitanosaka is location" } } }

    context "ログインしている場合" do
      it "口コミの投稿ができること" do
        post v1_hotel_reviews_path(hotel_id: accepted_hotel.id), params: params, headers: auth_tokens
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status :ok
        expect(response_body.length).to eq(8)
        expect(response_body).to include(title: "hotelName", content: "Kobe Kitanosaka is location")
      end

      it "paramsの値が不正な時は口コミの投稿ができないこと" do
        params = { review: { title: "", content: "Kobe Kitanosaka is location" } }
        post v1_hotel_reviews_path(hotel_id: accepted_hotel.id), params: params, headers: auth_tokens
        expect(response.status).to eq(400)
      end

      it "未承認のホテルへの口コミ投稿はできないこと" do 
        post v1_hotel_reviews_path(hotel_id: hotel.id), params: params, headers: auth_tokens
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body).not_to include( title: "hotelName")
        expect(response).to have_http_status(:not_found)
      end
    end

    context "ログインしていない場合" do
      it "口コミの投稿ができないこと" do
        post v1_hotel_reviews_path(hotel_id: accepted_hotel.id), params: params, headers: nil
        expect(response).to have_http_status(:unauthorized)
        expect(response.status).to eq(401)
      end
    end
  end

  describe "GET /v1/hotels/:hotel_id/reviews - v1/reviews#index" do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:auth_tokens) { client_user.create_new_auth_token }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: client_user.id) }

    context "口コミ一覧を取得できる場合" do
      it "口コミ自体が存在するホテルに書かれていること" do
        create(:review, user_id: client_user.id, hotel_id: accepted_hotel.id)
        get v1_hotel_reviews_path(hotel_id: accepted_hotel.id)
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:success)
        expect(response_body.length).to eq(1)
      end
    end

    context "口コミ一覧を取得できない場合" do
      it "ホテルそのものが存在しないこと" do
        unknow_hotel = create(:accepted_hotel, user_id: client_user.id)
        delete v1_hotel_path(id: unknow_hotel.id), headers: auth_tokens
        get v1_hotel_reviews_path(hotel_id: unknow_hotel.id)
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body.length).to eq(1)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /v1/review/:id - v1/reviews#destroy" do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:auth_tokens) { client_user.create_new_auth_token }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: client_user.id) }
    let_it_be(:review) { create(:review, user_id: client_user.id, hotel_id: accepted_hotel.id) }

    context "ログインしている場合" do
      it "ユーザーが投稿した口コミを削除できること" do
        expect do
          delete v1_user_review_path(id: review.id), headers: auth_tokens
        end.to change(Review, :count).by(-1)
        expect(response).to have_http_status :ok
      end

      it "自分が投稿していない口コミを削除できないこと" do
        user = create(:user)
        other_review = create(:review, hotel_id: accepted_hotel.id, user_id: user.id)
        expect do
          delete v1_user_review_path(id: other_review.id), headers: auth_tokens
        end.not_to change(Review, :count)
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "ログインしていない場合" do
      it "ユーザーが投稿した口コミを削除できないこと" do
        expect do
          delete v1_user_review_path(id: review.id), headers: nil
        end.not_to change(Review, :count)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH /v1/user/review/:id - v1/reviews#update" do
    let_it_be(:client_user)  { create(:user) }
    let_it_be(:auth_tokens)  { client_user.create_new_auth_token }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: client_user.id) }
    let_it_be(:review) { create(:review, user_id: client_user.id, hotel_id: accepted_hotel.id) }
    let_it_be(:params) { { review: { title: "title uploaded", content: "content uploaded" } } }

    context "ログインしている場合" do
      it "自分の投稿した口コミの編集ができること" do
        patch v1_user_review_path(id: review.id), params: params, headers: auth_tokens
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status :ok
        expect(response_body).to include(title: "title uploaded", content: "content uploaded")
      end

      it "自分が投稿していない口コミの編集ができないこと" do
        user = create(:user)
        different_review = create(:review, user_id: user.id, hotel_id: accepted_hotel.id)
        patch v1_user_review_path(id: different_review.id), params: params, headers: auth_tokens
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body).not_to include(title: "title uploaded", content: "content uploaded")
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "ログインしていない場合" do
      it "口コミの編集ができないこと" do
        patch v1_user_review_path(id: review.id), params: params
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:unauthorized)
        expect(response_body).not_to include(title: "title uploaded", content: "content uploaded")
      end
    end
  end

  describe "GET /v1/reviews/:id - v1/reviews#show" do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:auth_tokens) { client_user.create_new_auth_token }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: client_user.id) }

    context "口コミ詳細を取得できる場合" do
      it "口コミ自体が存在するホテルに書かれていること" do
        create(:review, user_id: client_user.id, hotel_id: accepted_hotel.id)
        get v1_hotel_reviews_path(hotel_id: accepted_hotel.id)
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:success)
        expect(response_body.length).to eq(1)
      end
    end

    context "口コミ詳細を取得できない場合" do
      it "ホテルそのものが存在しないこと" do
        unknow_hotel = create(:accepted_hotel, user_id: client_user.id)
        delete v1_hotel_path(id: unknow_hotel.id), headers: auth_tokens
        get v1_hotel_reviews_path(hotel_id: unknow_hotel.id)
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body.length).to eq(1)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

end

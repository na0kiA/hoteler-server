# frozen_string_literal: true

require "rails_helper"

RSpec.describe "V1::HotelImages", type: :request do
  describe "POST /v1/hotel/:hotel_id/images - v1/hotel/:hotel_id/images#create" do
    let_it_be(:client_user)  { create(:user) }
    let_it_be(:auth_tokens)  { client_user.create_new_auth_token }
    let_it_be(:hotel) { create(:accepted_hotel, user_id: client_user.id) }

    context "ログインしている場合" do
      it "ホテルの画像投稿ができること" do
        params = { hotel_image: { key: %w[key1998 key2001], hotel_id: hotel.id } }
        expect do
          post v1_hotel_images_path(hotel.id), params:, headers: auth_tokens
        end.to change(HotelImage, :count).by(2)
        expect(response.status).to eq(200)
      end
    end

    context "投稿するホテルの画像2つが同じ場合" do
      it "HotelImageは一つしか更新されないこと" do
        params = { hotel_image: { key: %w[key1998 key1998], hotel_id: hotel.id } }
        expect do
          post v1_hotel_images_path(hotel.id), params:, headers: auth_tokens
        end.to change(HotelImage, :count).by(1)
        expect(response.status).to eq(200)
      end
    end

    context "既に投稿してあるホテルに更に画像を追加できること" do
      let_it_be(:hotel_image) { create(:hotel_image, hotel_id: hotel.id) }

      it "HotelImageが一つ更新されること" do
        # 既存の古いkeyはフロントで配列の頭に状態維持されている
        params = { hotel_image: { key: [hotel_image.key, "key1999999"], hotel_id: hotel.id } }
        expect do
          post v1_hotel_images_path(hotel.id), params:, headers: auth_tokens
        end.to change(HotelImage, :count).by(1)
        expect(response.status).to eq(200)
      end
    end

    context "ログインしていない場合" do
      it "ホテルの画像投稿ができないこと" do
        params = { hotel_image: { key: %w[key1998 key2001], hotel_id: hotel.id } }
        post v1_hotel_images_path(hotel.id), params:, headers: nil
        expect(response.status).to eq(401)
        expect(response.message).to eq("Unauthorized")
      end
    end

    context "S3のkeyがない場合" do
      it "400を返すこと" do
        params = { hotel_image: { key: [""] } }
        expect do
          post v1_hotel_images_path(hotel.id), params:, headers: auth_tokens
        end.not_to change(HotelImage, :count)
        expect(response.status).to eq(400)
        expect(response.message).to eq("Bad Request")
      end
    end
  end

  describe "GET /v1/hotel/:hotel_id/images - v1/hotel/:hotel_id/images#index" do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:hotel) { create(:accepted_hotel, user_id: client_user.id) }
    let_it_be(:hotel_image) { create_list(:hotel_image, 3, hotel_id: hotel.id) }

    context "承認されているホテルの場合" do
      it "ホテルの画像一覧を取得できること" do
        get v1_hotel_images_path(hotel.id), headers: nil
        expect(response.status).to eq(200)
        expect(symbolized_body(response)[:hotelImages].length).to eq(3)
      end
    end

    context "ホテルの画像が３つから２つになった場合" do
      let_it_be(:auth_tokens) { client_user.create_new_auth_token }

      before do
        post v1_hotel_images_path(hotel.id), params: { hotel_image: { key: %w[key1010 key1020] } }, headers: auth_tokens
      end

      it "ホテルの画像一覧を２つ取得できること" do
        get v1_hotel_images_path(hotel.id), headers: nil
        expect(response.status).to eq(200)
        expect(symbolized_body(response)[:hotelImages].length).to eq(2)
      end
    end

    context "ホテルが削除された場合" do
      let_it_be(:auth_tokens) { client_user.create_new_auth_token }

      before do
        delete v1_hotel_path(hotel.id), headers: auth_tokens
      end

      it "ホテルの画像一覧を取得できないこと" do
        get v1_hotel_images_path(hotel.id)
        expect(response.status).to eq(404)
        expect(symbolized_body(response)[:errors][:title]).to eq("404 NOT FOUND")
        expect(symbolized_body(response)[:errors][:body]).to eq("既に削除されてあるか、存在しないページです")
      end
    end

    context "承認されていないホテルの場合" do
      let_it_be(:hidden_hotel) { create(:hotel, user_id: client_user.id) }
      let_it_be(:hotel_image) { create_list(:hotel_image, 3, hotel_id: hidden_hotel.id) }
      let_it_be(:auth_tokens) { client_user.create_new_auth_token }

      it "ホテル運営者以外はホテルの画像一覧を取得できないこと" do
        get v1_hotel_images_path(hidden_hotel.id)
        expect(response.status).to eq(404)
        expect(symbolized_body(response)[:errors][:title]).to eq("404 NOT FOUND")
        expect(symbolized_body(response)[:errors][:body]).to eq("既に削除されてあるか、存在しないページです")
      end

      it "ホテル運営者のみ画像一覧を取得できること" do
        get v1_hotel_images_path(hidden_hotel.id), headers: auth_tokens
        expect(response.status).to eq(200)
        expect(symbolized_body(response)[:hotelImages].length).to eq(3)
      end
    end
  end

  describe "GET /v1/hotel/:hotel_id/image/:id - v1/hotel/:hotel_id/image/:id #show" do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:hotel) { create(:accepted_hotel, user_id: client_user.id) }
    let_it_be(:hotel_image) { create_list(:hotel_image, 3, hotel_id: hotel.id) }

    context "承認されているホテルの場合" do
      it "ホテルの画像詳細を取得できること" do
        get v1_hotel_image_path(hotel.id, hotel_image[0].id)
        expect(response.status).to eq(200)
        expect(symbolized_body(response)[:hotelImage].length).to eq(3)
      end
    end

    context "画像が存在しない場合" do
      let_it_be(:auth_tokens) { client_user.create_new_auth_token }

      before do
        delete v1_hotel_path(hotel.id), headers: auth_tokens
      end

      it "ホテルの画像一覧を取得できないこと" do
        get v1_hotel_image_path(hotel.id, hotel_image[0].id)
        expect(response.status).to eq(404)
        expect(symbolized_body(response)[:errors][:title]).to eq("404 NOT FOUND")
        expect(symbolized_body(response)[:errors][:body]).to eq("既に削除されてあるか、存在しないページです")
      end
    end

    context "承認されていないホテルの場合" do
      let_it_be(:hidden_hotel) { create(:hotel, user_id: client_user.id) }
      let_it_be(:hotel_image) { create_list(:hotel_image, 3, hotel_id: hidden_hotel.id) }
      let_it_be(:auth_tokens) { client_user.create_new_auth_token }

      it "ホテル運営者以外はホテルの画像詳細を取得できないこと" do
        get v1_hotel_image_path(hidden_hotel.id, hotel_image[0].id)
        expect(response.status).to eq(404)
        expect(symbolized_body(response)[:errors][:title]).to eq("404 NOT FOUND")
        expect(symbolized_body(response)[:errors][:body]).to eq("既に削除されてあるか、存在しないページです")
      end

      it "ホテル運営者のみ画像詳細を取得できること" do
        get v1_hotel_image_path(hidden_hotel.id, hotel_image[0].id), headers: auth_tokens
        expect(response.status).to eq(200)
        expect(symbolized_body(response)[:hotelImage].length).to eq(3)
      end
    end
  end
end

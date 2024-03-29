# frozen_string_literal: true

require "rails_helper"

RSpec.describe "V1::Hotels", type: :request do
  describe "POST /v1/hotels - v1/hotels#create" do
    let_it_be(:client_user)  { create(:user) }
    let_it_be(:auth_tokens)  { client_user.create_new_auth_token }
    let_it_be(:params) {
      { hotel: { name: "神戸北野", content: "最高峰のラグジュアリーホテルをお届けします", company: "株式会社ホテルサービス", phone_number: "030-1111-1111", prefecture: "東京", city: "渋谷区", street_address: "2丁目11-1",
                 postal_code: "332-2344", user_id: client_user.id } }
    }

    context "ログインしている場合" do
      it "ホテルの投稿ができること" do
        expect do
          post v1_hotels_path, params:, headers: auth_tokens
        end.to change(Hotel.all, :count).by(1)
        expect(response).to have_http_status :ok
      end
    end

    context "ログインしていない場合" do
      it "ホテルの投稿ができないこと" do
        post v1_hotels_path, params:, headers: nil
        expect(response).to have_http_status(:unauthorized)
        expect(response.message).to include("Unauthorized")
      end
    end

    context "ホテルの投稿ができない場合" do
      it "400を返すこと" do
        params = { hotel: { name: "", content: "hotelContent" } }
        post v1_hotels_path, params:, headers: auth_tokens
        expect(response).to have_http_status(:bad_request)
        expect(response.message).to include("Bad Request")
      end
    end
  end

  describe "PATCH /v1/hotel - v1/hotels#update" do
    let_it_be(:client_user)  { create(:user) }
    let_it_be(:auth_tokens)  { client_user.create_new_auth_token }
    let_it_be(:accepted_hotel) { create(:completed_profile_hotel, user: client_user) }
    let_it_be(:edited_params) {
      { hotel: { name: "ホテルレジャー", content: "ホテルの名前が変わりました", user_id: client_user.id }, notification: { message: "ホテルの名前が変わりました" } }
    }

    context "ログインしている場合" do
      it "自分の投稿したホテルの編集ができること" do
        patch v1_hotel_path(accepted_hotel.id), params: edited_params, headers: auth_tokens

        expect(response).to have_http_status :ok
      end

      it "他人が投稿したホテルの編集ができないこと" do
        other_user = create(:user)
        hotel = create(:accepted_hotel, user_id: other_user.id)
        params = { hotel: { name: "神戸北野", content: "最高峰のラグジュアリーホテルをお届けします", user_id: client_user.id } }
        patch v1_hotel_path(hotel.id), params:, headers: auth_tokens
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "ログインしていない場合" do
      it "ホテルの編集ができないこと" do
        params = { hotel: { name: "神戸北野", content: "最高峰のラグジュアリーホテルをお届けします", user_id: client_user.id } }
        patch(v1_hotel_path(accepted_hotel.id), params:)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "お気に入りに登録しているユーザーがいる場合" do
      let_it_be(:favorite) { create(:with_user_favorite, hotel: accepted_hotel) }

      it "ホテルの編集時に更新メッセージと通知をユーザーに向けて登録できること" do
        params = { hotel: { name: "神戸北野", content: "最高峰のラグジュアリーホテルをお届けします。新しいソファーを設置しました。", user: client_user }, notification: { message: "新しいソファーを設置しました。" } }
        expect { patch v1_hotel_path(accepted_hotel.id), params:, headers: auth_tokens }.to change(Notification, :count).by(1)
        expect(favorite.user.notifications.first[:message]).to eq("新しいソファーを設置しました。")
      end
    end

    context "同じホテルを２回更新した場合" do
      let_it_be(:favorite) { create(:with_user_favorite, hotel: accepted_hotel) }

      it "お気に入り登録者に２回通知が行くこと" do
        params = { hotel: { name: "神戸北野", content: "最高峰のラグジュアリーホテルをお届けします。新しいソファーを設置しました。", user: client_user }, notification: { message: "新しいソファーを設置しました。" } }
        patch v1_hotel_path(accepted_hotel.id), params:, headers: auth_tokens

        re_update_params = { hotel: { name: "神戸北野", content: "最高峰のラグジュアリーホテルをお届けします", user: client_user }, notification: { message: "料金を下げました" } }
        patch v1_hotel_path(accepted_hotel.id), params: re_update_params, headers: auth_tokens

        expect(favorite.user.notifications.length).to eq(2)
        expect(favorite.user.notifications.first[:message]).to eq("料金を下げました")
      end
    end

    context "ホテルを空室から満室にのみ変更する場合" do
      let_it_be(:hotel) { create(:accepted_hotel, user: client_user) }
      let_it_be(:favorite) { create(:with_user_favorite, hotel:) }
      let_it_be(:only_changed_full_param) {
        { hotel: { name: hotel.name, content: hotel.content, phone_number: hotel.phone_number, postal_code: hotel.postal_code, street_address: hotel.street_address, prefecture: hotel.prefecture,
                   city: hotel.city, company: hotel.company, full: true } }
      }

      it "通知がユーザーに送信されないこと" do
        expect { patch v1_hotel_path(hotel.id), params: only_changed_full_param, headers: auth_tokens }.not_to change(Notification, :count)

        get v1_hotel_path(hotel.id)
        expect(symbolized_body(response)[:hotel][:full]).to be(true)

        hotel.reload
        expect(hotel.full).to be(true)
      end

      it "満室になっていること" do
        patch v1_hotel_path(hotel.id), params: only_changed_full_param, headers: auth_tokens
        expect(symbolized_body(response)[:hotel][:full]).to be(true)
      end
    end

    context "何も値を更新していないのに通知メッセージを付与した場合" do
      let_it_be(:hotel) { create(:accepted_hotel, user: client_user) }
      let_it_be(:favorite) { create(:with_user_favorite, hotel:) }
      let_it_be(:not_changed_param) {
        {
          hotel: { name: hotel.name, content: hotel.content, phone_number: hotel.phone_number, postal_code: hotel.postal_code, street_address: hotel.street_address, prefecture: hotel.prefecture,
                   city: hotel.city, company: hotel.company, full: false }, notification: { message: "何も変更していません" }
        }
      }

      it "通知がユーザーに送信されないこと" do
        expect { patch v1_hotel_path(hotel.id), params: not_changed_param, headers: auth_tokens }.not_to change(Notification, :count)
      end
    end

    context "通知メッセージが空の場合" do
      let_it_be(:favorite) { create(:with_user_favorite, hotel: accepted_hotel) }

      it "ホテルを更新できないこと" do
        params = { hotel: { name: "神戸北野", content: "最高峰のラグジュアリーホテルをお届けします", user: client_user }, notification: { message: "" } }
        patch v1_hotel_path(accepted_hotel.id), params:, headers: auth_tokens

        expect(response.status).to eq(400)
        expect(favorite.user.notifications).to eq([])
      end
    end
  end

  describe "DELETE /v1/hotels - v1/hotels#destroy" do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:auth_tokens) { client_user.create_new_auth_token }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user: client_user) }

    context "ログインしている場合" do
      it "ユーザーが投稿したホテルを削除できること" do
        expect do
          delete v1_hotel_path(accepted_hotel.id), headers: auth_tokens
        end.to change(Hotel, :count).by(-1)
        expect(response).to have_http_status :ok
      end

      it "自分が投稿していないホテルを削除できないこと" do
        user = create(:user)
        hotel = create(:accepted_hotel, user_id: user.id)
        expect do
          delete v1_hotel_path(hotel.id), headers: auth_tokens
        end.not_to change(Hotel, :count)
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "ログインしていない場合" do
      it "ユーザーが投稿したホテルを削除できないこと" do
        expect do
          delete v1_hotel_path(accepted_hotel.id), headers: nil
        end.not_to change(Hotel, :count)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /v1/hotels - v1/hotels#index" do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:auth_tokens) { client_user.create_new_auth_token }
    let_it_be(:accepted_hotel) { create(:completed_profile_hotel, :with_days_and_service_rates, user: client_user) }
    let_it_be(:hotel_image) { create_list(:hotel_image, 3, hotel: accepted_hotel) }

    context "月曜から木曜の料金が設定されてある場合" do
      let_it_be(:hotel) { create(:accepted_hotel, user: create(:user)) }
      let_it_be(:rest_rate) { create(:rest_rate, :normal_rest_rate, hotel:, day: hotel.days.first) }

      before do
        travel_to Time.zone.local(2023, 4, 18, 12, 0, 0)
      end

      it "料金を返すこと" do
        get v1_search_index_path, params: { keyword: "hotel" }
        expect(symbolized_body(response)[:hotels][0][:restRates][:rate]).to eq(3280)
      end
    end

    context "ホテルが承認されている場合" do
      it "ホテル一覧を取得できること" do
        get v1_hotels_path
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:success)
        expect(response_body[:hotels][0][:reviewsCount]).to eq(0)
        expect(response_body[:hotels].length).to eq 1
      end

      it "ホテルを複数個取得できること" do
        create_list(:completed_profile_hotel, 2, :with_days_and_service_rates, :with_user)
        get v1_hotels_path
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:success)
        expect(response_body[:hotels].length).to eq 3
      end
    end

    context "ホテルが承認されていない場合" do
      let_it_be(:hidden_hotel) { create(:hotel, user: client_user) }

      it "ホテル一覧を取得できないこと" do
        get v1_hotels_path
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body[:hotels].length).not_to eq 2
      end
    end

    context "ホテルが満室の場合" do
      let_it_be(:hotel) { create(:accepted_hotel, full: true, user: client_user) }

      it "ホテル一覧の2つ目のホテルが満室になっていること" do
        get v1_hotels_path
        expect(symbolized_body(response)[:hotels][1][:full]).to be(true)
      end
    end
  end

  describe "GET /v1/hotel/:id - v1/hotels#show" do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:hidden_hotel) { create(:hotel, user: client_user) }
    let_it_be(:auth_tokens) { client_user.create_new_auth_token }
    let_it_be(:accepted_hotel) { create(:completed_profile_hotel, :with_days_and_service_rates, user: client_user) }
    let_it_be(:hotel_image) { create(:hotel_image, hotel: accepted_hotel) }

    context "ホテルが承認されている場合" do
      it "ホテル詳細を取得できること" do
        get v1_hotel_path(accepted_hotel.id)
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:success)
        expect(response_body[:hotel].length).to eq(19)
      end

      it "口コミの評価率と評価数が取得できること" do
        get v1_hotel_path(accepted_hotel.id)
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:success)
        expect(response_body[:hotel][:reviewsCount]).to eq(0)
        expect(response_body[:hotel][:averageRating]).to eq("0.0")
      end
    end

    context "口コミが新しく記述された場合" do
      let_it_be(:other_user) { create(:user) }
      let_it_be(:other_user_auth_tokens) { other_user.create_new_auth_token }

      before do
        params = { review: { title: "綺麗でした", content: "また行こうと思っています", five_star_rate: 5 } }
        post v1_hotel_reviews_path(hotel_id: accepted_hotel.id), params:, headers: other_user_auth_tokens
      end

      it "ホテルの口コミカウントが更新されること" do
        get v1_hotel_path(accepted_hotel.id)
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body[:hotel][:reviewsCount]).to eq(1)
      end

      it "ホテルの五つ星が更新されること" do
        get v1_hotel_path(accepted_hotel.id)
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response_body[:hotel][:averageRating]).to eq("5.0")
      end
    end

    context "ホテルが承認されていない場合" do
      it "ホテル詳細を取得できないこと" do
        get v1_hotel_path(hidden_hotel.id)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "存在しないホテルを取得しようとした場合" do
      it "404 NOT FOUND を返すこと" do
        get v1_hotel_path(10**5)
        expect(response).to have_http_status(:not_found)
        expect(response.message).to eq("Not Found")
      end
    end
  end
end

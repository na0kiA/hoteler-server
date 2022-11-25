# frozen_string_literal: true

require "rails_helper"

RSpec.describe "V1::Notifications", type: :request do
  describe "GET /v1/index - v1/notifications #index" do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:auth_tokens) { client_user.create_new_auth_token }
    let_it_be(:accepted_hotel) { create(:with_user_completed_hotel) }
    let_it_be(:hotel_auth_tokens) { accepted_hotel.user.create_new_auth_token }

    context "通知一覧を取得できる場合" do
      let_it_be(:favorite) { create(:favorite, hotel: accepted_hotel, user: client_user) }
      let_it_be(:update_params) { { hotel: { name: "神戸北野", content: "最高峰のラグジュアリーホテルをお届けします", user_id: client_user }, message: "新しいソファーを設置しました。" } }

      before do
        patch v1_hotel_path(accepted_hotel.id), params: update_params, headers: hotel_auth_tokens
      end

      it "お気に入りに登録したホテルの更新の通知を受け取ること" do
        get v1_notifications_path, headers: auth_tokens
        expect(symbolized_body(response)[0][:message]).to eq("新しいソファーを設置しました。")
        expect(symbolized_body(response)[0][:title]).to eq("神戸北野さまがホテルを更新しました")
      end

      it "通知を新しい順に受け取ること" do
        params = { hotel: { name: "神戸北野", content: "最高峰のラグジュアリーホテルをお届けします", user_id: client_user }, message: "リニューアルオープンしました。" }
        patch v1_hotel_path(accepted_hotel.id), params:, headers: hotel_auth_tokens
        expect(client_user.notifications.length).to eq(2)
        expect(client_user.notifications.first[:message]).to eq("リニューアルオープンしました。")
      end
    end

    context "通知をユーザーが表示した場合" do
      let_it_be(:favorite) { create(:favorite, hotel: accepted_hotel, user: client_user) }
      let_it_be(:update_params) { { hotel: { name: "神戸北野", content: "最高峰のラグジュアリーホテルをお届けします", user_id: client_user }, message: "新しいソファーを設置しました。" } }

      before do
        patch v1_hotel_path(accepted_hotel.id), params: update_params, headers: hotel_auth_tokens
      end

      it "readがtrueになり既読済みになること" do
        get v1_notifications_path, headers: auth_tokens
        expect(symbolized_body(response)[0][:read]).to be(true)
      end
    end

    context "お気に入りに登録していないホテルが更新された場合" do
      let_it_be(:update_params) { { hotel: { name: "神戸北野", content: "最高峰のラグジュアリーホテルをお届けします", user_id: client_user }, message: "新しいソファーを設置しました。" } }
      let_it_be(:favorites) { create(:with_hotel_favorite, user: client_user) }

      before do
        patch v1_hotel_path(accepted_hotel.id), params: update_params, headers: hotel_auth_tokens
      end

      it "通知を受け取らないこと" do
        get v1_notifications_path, headers: auth_tokens
        expect(response.status).to eq(200)
        expect(symbolized_body(response)[:title]).to eq("まだ通知はありません。")
      end
    end

    context "ホテルに口コミが書かれた場合" do
      let_it_be(:review_params) { { review: { title: "部屋が綺麗", content: "また行こうと思っています", five_star_rate: 5 } } }

      before do
        post v1_hotel_reviews_path(accepted_hotel.id), params: review_params, headers: auth_tokens
      end

      it "ホテル運営者は口コミの通知を受け取ること" do
        get v1_notifications_path, headers: hotel_auth_tokens
        expect(response.status).to eq(200)
        expect(symbolized_body(response)[0][:title]).to eq("#{accepted_hotel.reviewer.pick(:name)}さんがあなたのホテルに星#{accepted_hotel.reviews.pick(:five_star_rate)}つの口コミを投稿しました")
        expect(symbolized_body(response)[0][:message]).to eq("部屋が綺麗")
      end
    end

    context "ホテルに口コミが一つも無い場合" do
      it "通知を受け取らないこと" do
        get v1_notifications_path, headers: hotel_auth_tokens
        expect(response.status).to eq(200)
        expect(symbolized_body(response)[:title]).to eq("まだ通知はありません。")
      end
    end
  end
end

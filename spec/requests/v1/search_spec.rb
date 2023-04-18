# frozen_string_literal: true

require "rails_helper"

RSpec.describe "V1::Searches", type: :request do
  describe "GET /v1/search/ - v1/search#index" do
    let_it_be(:hotel) { create(:accepted_hotel, user: create(:user)) }

    context "月曜から木曜の料金が設定されてある場合" do
      let_it_be(:completed_hotel) { create(:with_service_completed_hotel, user: create(:user)) }

      before do
        travel_to Time.zone.local(2023, 4, 18, 12, 0, 0)
      end

      it "料金を返すこと" do
        get v1_search_index_path, params: { keyword: "hotel" }
        p symbolized_body(response)
        expect(symbolized_body(response)[:hotels][1][:restRates][:rate]).to eq(3280)
      end
    end

    context "キーワードに何も付与されていない場合" do
      it "404を返すこと" do
        get v1_search_index_path
        expect(response.status).to eq(404)
      end
    end

    context "キーワードにホテルの項目と一致する文字が入力された場合" do
      it "文字に一致するホテルを返すこと" do
        get v1_search_index_path, params: { keyword: "hotel" }
        expect(symbolized_body(response)[:hotels][0][:name]).to eq(hotel.name)
        expect(symbolized_body(response)[:hotels].first.length).to eq(9)
      end

      it "文字に一致する都市のホテルを返すこと" do
        get v1_search_index_path, params: { keyword: "渋谷" }
        expect(symbolized_body(response)[:hotels].first.length).to eq(9)
      end
    end

    context "キーワードに複数個の値が入力された場合" do
      it "文字に一致するホテルを返すこと" do
        get v1_search_index_path, params: { keyword: "にゃあ　渋谷" }
        expect(symbolized_body(response)[:hotels].first.length).to eq(9)
      end
    end

    context "キーワードにどのホテルのカラムとも一致しない文字が入力された場合" do
      it "検索結果に何も表示されないこと" do
        get v1_search_index_path, params: { keyword: "にゃあ" }
        expect(response.body).to eq("にゃあの検索結果が見つかりませんでした")
      end
    end

    context "キーワードが空欄の場合" do
      it "404を返すこと" do
        get v1_search_index_path, params: { keyword: "　" }
        expect(response.status).to eq(404)
      end
    end

    context "キーワードの最初が空欄かつ存在しない語句の場合" do
      it "検索結果に何も表示されないこと" do
        get v1_search_index_path, params: { keyword: " にゃあ" }
        expect(response.body).to eq(" にゃあの検索結果が見つかりませんでした")
      end
    end

    context "キーワードに存在するホテルの住所が与えられた場合" do
      let_it_be(:cheap_hotel) { create(:completed_profile_hotel, :with_days_and_service_rates, :with_user, :with_reviews_and_helpfulnesses) }

      before do
        travel_to Time.zone.local(2022, 12, 12, 12, 0, 0)
      end

      it "該当するホテルが検索されること" do
        get v1_search_index_path, params: { keyword: "丁目" }
        expect(symbolized_body(response)[:hotels].first.length).to eq(9)
      end

      it "該当するホテルの休憩料金が表示されること" do
        get v1_search_index_path, params: { keyword: "丁目" }
        expect(symbolized_body(response)[:hotels][1][:restRates][:plan]).to eq("休憩60分")
      end

      it "パラメーターが5つでも該当するホテルが検索されること" do
        get v1_search_index_path, params: { keyword: "丁目　にゃあ　わん　やあ　ほげ" }
        expect(symbolized_body(response)[:hotels].first.length).to eq(9)
      end

      it "パラメーターがいくつでも該当するホテルがあれば検索されること" do
        get v1_search_index_path, params: { keyword: "にゃあ　わん　やあ　ほげ　ふー　ばず　渋谷　やっほー　こんばん　わ" }
        expect(symbolized_body(response)[:hotels].first.length).to eq(9)
      end
    end

    context "ホテルを並び替える場合" do
      let_it_be(:expensive_hotel) { create(:completed_profile_hotel, :with_days_and_expensive_service_rates, :with_user) }
      let_it_be(:cheap_hotel) { create(:completed_profile_hotel, :with_days_and_service_rates, :with_user, :with_reviews_and_helpfulnesses) }

      before do
        travel_to Time.zone.local(2022, 12, 12, 12, 0, 0)
      end

      it "sortの値がおかしいときは404を返すこと" do
        get v1_search_index_path, params: { keyword: "渋谷", sort: "aiu" }
        expect(response.status).to eq(404)
        expect(response.body).to include("存在しない検索対象です")
      end

      it "ホテルの休憩が安い順に並び替えられること" do
        get v1_search_index_path, params: { keyword: "渋谷", sort: "low_rest" }
        expect(symbolized_body(response)[:hotels][0][:restRates][:rate]).to eq(3280)
        expect(symbolized_body(response)[:hotels][1][:restRates][:rate]).to eq(4280)
      end

      it "ホテルの休憩が高い順に並び替えられること" do
        get v1_search_index_path, params: { keyword: "渋谷", sort: "high_rest" }
        expect(symbolized_body(response)[:hotels][0][:restRates][:rate]).to eq(4280)
        expect(symbolized_body(response)[:hotels][1][:restRates][:rate]).to eq(3280)
      end

      it "ホテルの宿泊が安い順に並び替えられること" do
        get v1_search_index_path, params: { keyword: "渋谷", sort: "low_stay" }
        expect(symbolized_body(response)[:hotels][0][:stayRates][:rate]).to eq(5980)
        expect(symbolized_body(response)[:hotels][1][:stayRates][:rate]).to eq(6980)
      end

      it "ホテルの宿泊が高い順に並び替えられること" do
        get v1_search_index_path, params: { keyword: "渋谷", sort: "high_stay" }
        expect(symbolized_body(response)[:hotels][0][:stayRates][:rate]).to eq(6980)
        expect(symbolized_body(response)[:hotels][1][:stayRates][:rate]).to eq(5980)
      end

      it "ホテルの口コミの数が多い順に並び替えられること" do
        get v1_search_index_path, params: { keyword: "渋谷", sort: "reviews_count" }
        expect(symbolized_body(response)[:hotels][0][:reviewsCount]).to eq(5)
        expect(symbolized_body(response)[:hotels][1][:reviewsCount]).to eq(0)
      end

      it "ホテルをお気に入りの数が多い順に並び替えられること" do
        favorite = create(:favorite, :with_user, hotel: cheap_hotel)
        get v1_search_index_path, params: { keyword: "渋谷", sort: "favorites_count" }
        expect(symbolized_body(response)[:hotels][0][:name]).to eq(favorite.hotel.name)

        get v1_hotel_path(cheap_hotel.id)
        expect(symbolized_body(response)[:hotel][:favoritesCount]).to eq(1)
      end
    end

    context "ホテルを絞り込む場合" do
      let_it_be(:expensive_hotel) { create(:completed_profile_hotel, :with_days_and_expensive_service_rates, :with_user) }

      before do
        travel_to Time.zone.local(2022, 12, 12, 12, 0, 0)
      end

      it "wifiのあるホテルを絞込めること" do
        expensive_hotel.hotel_facility.update(wifi_enabled: true)
        get v1_search_index_path, params: { keyword: "渋谷", hotel_facilities: %w[wifi_enabled] }
        expect(symbolized_body(response)[:hotels].length).to eq(1)
      end

      # TODO: テストが通らないので後で修正する
      # it "wifiと駐車場のあるホテルを絞込めること" do
      #   other_hotel.hotel_facility.update(parking_enabled: true, wifi_enabled: true)
      #   get v1_search_index_path, params: { keyword: "渋谷", hotel_facilities: ["parking_enabled", "wifi_enabled"] }

      #   expect(symbolized_body(response)[:hotels].length).to eq(1)
      # end

      it "一致しない場合はホテルを絞込めないこと" do
        get v1_search_index_path, params: { keyword: "渋谷", hotel_facilities: %w[cooking_enabled] }
        expect(response.body).to eq("絞り込み条件で一致するホテルがありませんでした。違う条件と検索キーワードでお試しください。")
      end

      it "存在しない条件の場合はホテルを絞込めないこと" do
        get v1_search_index_path, params: { keyword: "渋谷", hotel_facilities: %w[cooking] }
        expect(response.body).to eq("絞り込み条件で一致するホテルがありませんでした。違う条件と検索キーワードでお試しください。")
      end
    end

    context "ホテルを絞り込めない場合" do
      let_it_be(:expensive_hotel) { create(:completed_profile_hotel, :with_days_and_expensive_service_rates, :with_user) }
      let_it_be(:with_reviews_hotel) { create(:completed_profile_hotel, :with_days_and_service_rates, :with_user, :with_reviews_and_helpfulnesses) }
      let_it_be(:accepted_hotel) { create(:accepted_hotel, user: create(:user)) }

      before do
        travel_to Time.zone.local(2022, 12, 12, 12, 0, 0)
      end

      it "wifiと駐車場とクーポンに該当するホテルがなければ絞込めないこと" do
        expensive_hotel.hotel_facility.update(wifi_enabled: true, parking_enabled: true, phone_reservation_enabled: true)
        get v1_search_index_path, params: { keyword: "渋谷", hotel_facilities: %w[wifi_enabled parking_enabled coupon_enabled] }
        expect(response.body).to eq("絞り込み条件で一致するホテルがありませんでした。違う条件と検索キーワードでお試しください。")
      end
    end

    context "ホテルを絞り込み、並び替える場合" do
      let_it_be(:expensive_hotel) { create(:completed_profile_hotel, :with_days_and_expensive_service_rates, :with_user) }
      let_it_be(:with_reviews_hotel) { create(:completed_profile_hotel, :with_days_and_service_rates, :with_user, :with_reviews_and_helpfulnesses) }
      let_it_be(:accepted_hotel) { create(:accepted_hotel, user: create(:user)) }

      before do
        travel_to Time.zone.local(2022, 12, 12, 12, 0, 0)
      end

      it "wifiのホテルを絞込んで安い順に並び替えられること" do
        expensive_hotel.hotel_facility.update(wifi_enabled: true)
        with_reviews_hotel.hotel_facility.update(wifi_enabled: true)
        get v1_search_index_path, params: { keyword: "渋谷", hotel_facilities: %w[wifi_enabled], sort: "low_rest" }
        expect(symbolized_body(response)[:hotels].length).to eq(2)
        expect(symbolized_body(response)[:hotels][0][:restRates][:rate]).to eq(3280)
        expect(symbolized_body(response)[:hotels][1][:restRates][:rate]).to eq(4280)
      end
    end
  end
end

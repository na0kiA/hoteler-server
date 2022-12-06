# frozen_string_literal: true

require "rails_helper"

RSpec.describe "V1::Searches", type: :request do
  describe "GET /v1/search/ - v1/search#index" do
    let_it_be(:hotel) { create(:accepted_hotel, user: create(:user)) }

    context "キーワードに何も付与されていない場合" do
      it "トップページを返すこと" do
        get v1_search_index_path
        expect(response.status).to eq(302)
        expect(response.body).to include("redirected")
      end
    end

    context "キーワードにホテルの項目と一致する文字が入力された場合" do
      it "文字に一致するホテルを返すこと" do
        get v1_search_index_path, params: { keyword: "hotel" }
        expect(symbolized_body(response)[0][:name]).to eq(hotel.name)
        expect(symbolized_body(response).first.length).to eq(13)
      end

      it "文字に一致する都市のホテルを返すこと" do
        get v1_search_index_path, params: { keyword: "渋谷" }
        expect(symbolized_body(response).first.length).to eq(13)
      end
    end

    context "キーワードに複数個の値が入力された場合" do
      it "文字に一致するホテルを返すこと" do
        get v1_search_index_path, params: { keyword: "にゃあ　渋谷" }
        expect(symbolized_body(response).first.length).to eq(13)
      end
    end

    context "キーワードにどのホテルのカラムとも一致しない文字が入力された場合" do
      it "検索結果に何も表示されないこと" do
        get v1_search_index_path, params: { keyword: "にゃあ" }
        expect(response.body).to eq("にゃあの検索結果が見つかりませんでした")
      end
    end

    context "キーワードが空欄の場合" do
      it "検索結果に何も表示されないこと" do
        get v1_search_index_path, params: { keyword: "　" }
        expect(response.status).to eq(302)
        expect(response.body).to include("redirected")
      end
    end

    context "キーワードの最初が空欄かつ存在しない語句の場合" do
      it "検索結果に何も表示されないこと" do
        get v1_search_index_path, params: { keyword: " にゃあ" }
        expect(response.body).to eq(" にゃあの検索結果が見つかりませんでした")
      end
    end

    context "市区町村に存在するホテルの住所のパラメーターに与えられた場合" do
      it "該当するホテルが検索されること" do
        get v1_search_index_path, params: { city_and_street_address: "丁目" }
        expect(symbolized_body(response).first.length).to eq(13)
      end

      it "パラメーターが5つでも該当するホテルが検索されること" do
        get v1_search_index_path, params: { city_and_street_address: "丁目　にゃあ　わん　やあ　ほげ" }
        expect(symbolized_body(response).first.length).to eq(13)
      end

      it "パラメーターが7つでも該当するホテルが検索されること" do
        get v1_search_index_path, params: { city_and_street_address: "にゃあ　わん　やあ　ほげ　ふー　ばず　渋谷" }
        expect(symbolized_body(response).first.length).to eq(13)
      end
    end

    context "市区町村に存在しないホテルの住所のパラメーターに与えられた場合" do
      it "該当するホテルが検索されないこと" do
        get v1_search_index_path, params: { city_and_street_address: "にゃあ" }
        expect(response.body).to eq("にゃあの検索結果が見つかりませんでした")
      end
    end

    context "安い順に絞り込む場合" do
      let_it_be(:cheap_hotel) { create(:completed_profile_hotel, :with_days_and_service_rates, :with_user) }
      let_it_be(:expensive_hotel) { create(:completed_profile_hotel, :with_days_and_expensive_service_rates, :with_user) }

      it "ホテルが安い順に並び替えられること" do
        get v1_search_index_path
        expect(symbolized_body(response)).to eq("d")
      end
    end
  end
end

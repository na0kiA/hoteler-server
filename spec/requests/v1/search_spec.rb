require 'rails_helper'

RSpec.describe "V1::Searches", type: :request do
  describe "GET /v1/search/ - v1/search#index" do
    let_it_be(:hotel) { create(:accepted_hotel, user: create(:user)) }

    context '検索用のパラメーターに何も付与されていない場合' do
      it 'トップページを返すこと' do
        get v1_search_index_path
        expect(response.status).to eq(302)
        expect(response.body).to include("redirected")
      end
    end

    context '検索用のパラメーターにホテルの項目と一致する文字が入力された場合' do
      it '文字に一致するホテルを返す' do
        get v1_search_index_path, params: {keyword: "hotel"}
        expect(symbolized_body(response)[0][:name]).to eq(hotel.name)
        expect(symbolized_body(response).first.length).to eq(13)
      end

      it '文字に一致する都市のホテルを返す' do
        get v1_search_index_path, params: {keyword: "渋谷"}
        expect(symbolized_body(response).first.length).to eq(13)
      end
    end

    context '検索用のパラメーターに複数個の値が入力された場合' do
      it '文字に一致するホテルを返す' do
        get v1_search_index_path, params: {keyword: "にゃあ 渋谷"}
        p symbolized_body(response)
        expect(symbolized_body(response).first.length).to eq(13)
      end
    end

    context '検索用のパラメーターにどのホテルのカラムとも一致しない文字が入力された場合' do
      it '検索結果に何も表示されないこと' do
        get v1_search_index_path, params: {keyword: "にゃあ"}
        expect(symbolized_body(response)).to eq([])
      end
    end
  end
end

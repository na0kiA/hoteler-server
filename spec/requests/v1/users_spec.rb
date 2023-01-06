# frozen_string_literal: true

require "rails_helper"

RSpec.describe "V1::Users", type: :request do
  describe "GET /v1/users/:id - v1/users#show" do
    context "ユーザーが存在する場合" do
      let_it_be(:client_user) { create(:user) }

      it "フロントに返すJSONのキーは5つであること" do
        get v1_user_path(client_user.id)
        expect(symbolized_body(response).length).to eq(5)
      end

      it "デフォルトの画像が表示されること" do
        get v1_user_path(client_user.id)
        expect(symbolized_body(response)[:image]).to eq("https://hoteler-image.s3.ap-northeast-1.amazonaws.com/uploads/hoteler/b0e2987c-016e-4ce6-8099-fb8ae43115fc/blank-profile-picture-g89cfeb4dc_640.png")
      end
    end

    context "ユーザーが存在しない場合" do
      it "404を返すこと" do
        get v1_user_path(11_111_111_111)
        expect(response.status).to eq(404)
      end
    end

    context "ユーザーの画像が設定されている場合" do
      let_it_be(:client_user) { create(:user, image: "aws/s3/keys/") }

      it "keyが変換されたfile_urlが表示されること" do
        get v1_user_path(client_user.id)
        expect(symbolized_body(response)[:image]).to include("https://")
      end
    end

    context "ユーザーの口コミがある場合" do
      let_it_be(:client_user) { create(:user) }
      let_it_be(:hotel) { create(:completed_profile_hotel, :with_user) }
      let_it_be(:review) { create_list(:review, 2, user: client_user, hotel:) }

      it "口コミが全て表示されること" do
        get v1_user_path(client_user.id)
        expect(symbolized_body(response)[:reviews][0][:userImage]).to include("https://")
        expect(symbolized_body(response)[:reviews].length).to eq(2)
      end
    end

    context "自身のプロフィールを見る場合" do
      let_it_be(:client_user) { create(:user) }
      let_it_be(:auth_tokens) { client_user.create_new_auth_token }
      let_it_be(:hotel) { create(:completed_profile_hotel, :with_user) }
      let_it_be(:favorite) { create(:favorite, hotel:, user: client_user) }

      it "お気に入り一覧が表示されること" do
        get v1_user_path(client_user.id), headers: auth_tokens
        expect(symbolized_body(response)[:favorites][0][:hotelName]).to eq(hotel.name)
      end
    end

    context "他人のプロフィールを見る場合" do
      let_it_be(:client_user) { create(:user) }
      let_it_be(:other_user_auth_tokens) { create(:user).create_new_auth_token }
      let_it_be(:hotel) { create(:completed_profile_hotel, :with_user) }
      let_it_be(:favorite) { create(:favorite, hotel:, user: client_user) }

      it "お気に入り一覧が表示されないこと" do
        get v1_user_path(client_user.id), headers: other_user_auth_tokens
        expect(symbolized_body(response)[:favorites]).to be_blank
      end
    end
  end
end

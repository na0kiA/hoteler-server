# frozen_string_literal: true

require "rails_helper"

RSpec.describe "V1::Users", type: :request do
  describe "GET /v1/users/:id - v1/users#show" do
    context "ユーザーが存在する場合" do
      let_it_be(:client_user) { create(:user) }

      it "ユーザーのJSONのキーを4つ返すこと" do
        get v1_user_path(client_user.id)
        expect(symbolized_body(response).length).to eq(4)
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
        expect(symbolized_body(response)[:reviews][0][:user_image]).to include("https://")
        expect(symbolized_body(response)[:reviews].length).to eq(2)
      end
    end
  end
end

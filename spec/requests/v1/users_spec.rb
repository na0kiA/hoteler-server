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
        expect(symbolized_body(response)[:image]).to eq("blank-profile-picture-g89cfeb4dc_640.png")
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
      let_it_be(:review) { create(:review, user: client_user, hotel: create(:completed_profile_hotel, :with_user)) }

      it "口コミが全て表示されること" do
        get v1_user_path(client_user.id)
        p symbolized_body(response)
        expect(symbolized_body(response)[:reviews]).to eq("https://")
      end
    end
  end
end

require 'rails_helper'

RSpec.describe "V1::Hotels", type: :request do
  describe "POST /create" do
    context "ログインしている場合" do
      it "POSTができること" do
        client_user = create(:user)
        auth_tokens = client_user.create_new_auth_token
        hotel = client_user.hotels.build(name: "sss", content: "sss")
        params = { hotel: hotel}
        post v1_hotels_path, params: params, headers: auth_tokens
        expect(response).to have_http_status :ok
      end
    end
  end
end

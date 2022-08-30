require 'rails_helper'

RSpec.describe 'V1::Images', type: :request do
  describe 'GET /v1/images - v1/images#signed_url' do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:auth_tokens) { client_user.create_new_auth_token }

    context 'ログインしている場合' do
      it '署名付きURLを発行できること' do
        get v1_images_path, headers: auth_tokens
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:success)
        expect(response_body[:url]).to include('https://')
        expect(response_body[:fields].length).to eq 8
      end
    end

    context 'ログインしていない場合' do
      it '署名付きURLを発行できないこと' do
        get v1_images_path, headers: nil
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:unauthorized)
        expect(response_body[:url]).to be_nil
        expect(response_body[:fields]).to be_nil
      end
    end
  end
end

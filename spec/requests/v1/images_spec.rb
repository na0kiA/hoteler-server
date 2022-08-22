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

  describe 'POST /v1/images/hotel - v1/images#save_hotel_key' do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:auth_tokens) { client_user.create_new_auth_token }

    # context "ログインしている場合" do
    #   it "ユーザーが投稿したホテル画像のS3のkeyをDBに保存できること" do
    #     key = { image: { hotel_s3_key: "uploads/hoteler/#{SecureRandom.uuid}/${filename}" } }
    #     expect do
    #       post v1_images_hotel_path, params: key, headers: auth_tokens
    #     end.to change(Image.all, :count).by(1)
    #     expect(response).to have_http_status(:no_content)
    #   end
    # end

    context 'ログインしていない場合' do
      it 'ユーザーが投稿したホテル画像のS3のkeyをDBに保存できないこと' do
        params = { image: { hotel_s3_key: "uploads/hoteler/#{SecureRandom.uuid}/${filename}" } }
        expect do
          post v1_images_hotel_path, params:, headers: nil
        end.not_to change(Image, :count)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /v1/images/user - v1/images#save_user_key' do
    let_it_be(:client_user) { create(:user) }
    let_it_be(:auth_tokens) { client_user.create_new_auth_token }

    # context "ログインしている場合" do
    #   it "ユーザーが投稿したプロフィール画像のS3のkeyをDBに保存できること" do
    #     key = { image: { user_s3_key: "uploads/hoteler/#{SecureRandom.uuid}/${filename}" } }
    #     expect do
    #       post v1_images_user_path, params: key, headers: auth_tokens
    #     end.to change(Image.all, :count).by(1)
    #     expect(response).to have_http_status(:no_content)
    #   end
    # end

    context 'ログインしていない場合' do
      it 'ユーザーが投稿したプロフィール画像のS3のkeyをDBに保存できないこと' do
        params = { image: { user_s3_key: "uploads/hoteler/#{SecureRandom.uuid}/${filename}" } }
        expect do
          post v1_images_user_path, params:, headers: nil
        end.not_to change(Image, :count)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end

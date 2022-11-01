# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Helpfulnesses', type: :request do
  describe 'POST /v1/reviews/:review_id/helpfulnesses - v1/helpfulness#create' do
    let_it_be(:client_user)  { create(:user) }
    let_it_be(:auth_tokens)  { client_user.create_new_auth_token }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: client_user.id) }
    let_it_be(:review) { create(:review, user_id: client_user.id, hotel_id: accepted_hotel.id) }

    context '参考になったを押せる場合' do
      it 'DBに保存ができること' do
        expect { post v1_helpfulnesses_path(review_id: review.id), headers: auth_tokens }.to change(Helpfulness, :count).by(1)
      end

      it 'statusが200なこと' do
        post v1_helpfulnesses_path(review_id: review.id), headers: auth_tokens
        expect(response.status).to eq(200)
      end
    end

    context '参考になったを押せない場合' do

      it 'ログインしていないとき、401エラーがでること' do
        expect { post v1_helpfulnesses_path(review_id: review.id), headers: }.not_to change(Helpfulness, :count)
        post v1_helpfulnesses_path(review_id: review.id), headers: nil
        response_body = JSON.parse(response.body, symbolize_names: true)
        expect(response.status).to eq(401)
        expect(response_body[:errors][0]).to eq('ログイン、もしくはアカウント登録をしてください。')
      end

      it '口コミが存在しないとき、エラーが表示されること' do
        post v1_helpfulnesses_path(0), headers: auth_tokens
        expect(response).to have_http_status(:bad_request)
        expect(symbolized_body(response)[:errors][:title]).to eq('存在しない口コミです')
      end
    end

    context '既に押している場合' do
      it 'destroyに内部リダイレクトされること' do
        expect { post v1_helpfulnesses_path(review_id: review.id), headers: auth_tokens }.to change(Helpfulness, :count).by(1)
        post v1_helpfulnesses_path(review_id: review.id), headers: auth_tokens
        expect(response.status).to eq(302)
      end
    end
  end

  describe 'DELETE /v1/reviews/:review_id/helpfulnesses - v1/helpfulness#destroy' do
    let_it_be(:client_user)  { create(:user) }
    let_it_be(:auth_tokens)  { client_user.create_new_auth_token }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: client_user.id) }
    let_it_be(:review) { create(:review, user_id: client_user.id, hotel_id: accepted_hotel.id) }

    context 'deleteができる場合' do
      let_it_be(:helpfulness) { Helpfulness.create(user_id: client_user.id, review_id: review.id) }

      it '200が帰ってきてdeleteできること' do
        delete v1_helpfulnesses_path(review_id: review.id), headers: auth_tokens
        expect(response.status).to eq(200)
      end
    end

    context 'ログインをしていなのに削除しようとした場合' do
      let_it_be(:helpfulness) { Helpfulness.create(user_id: client_user.id, review_id: review.id) }
      it '401が帰ってくること' do
        delete v1_helpfulnesses_path(review_id: review.id), headers: nil
        expect(response.status).to eq(401)
        expect(response.message).to include('Unauthorized')
      end
    end

    context '存在しない口コミにdeleteした場合' do
      let_it_be(:helpfulness) { Helpfulness.create(user_id: client_user.id, review_id: review.id) }
      it '400とカスタムエラーが帰ってくること' do
        delete v1_helpfulnesses_path(review_id: 0), headers: auth_tokens
        expect(response.status).to eq(400)
        expect(symbolized_body(response)[:errors][:title]).to eq('「参考になった」を取り消せません')
      end
    end

    context '「参考になった」を押していない場合' do
      it '400とカスタムエラーが帰ってくること' do
        delete v1_helpfulnesses_path(review_id: review.id), headers: auth_tokens
        expect(response.status).to eq(400)
        expect(symbolized_body(response)[:errors][:title]).to include('「参考になった」を取り消せません')
      end
    end
  end
end

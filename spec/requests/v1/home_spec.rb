# # frozen_string_literal: true

# require 'rails_helper'

# RSpec.describe 'V1::Home', type: :request do
#   describe 'GET /v1/home home#index' do
#     let_it_be(:client_user)  { create(:user) }
#     let_it_be(:auth_tokens) { client_user.create_new_auth_token }

#     context 'TOPページにアクセスした場合' do

#       before do
#         get '/v1', headers: auth_tokens
#       end

#       it '承認済みホテルの名前を返すこと' do
#         expect(response.status).to eq(200)
#         p response
#         expect(response.body).to eq('s')
#       end
#     end
#   end
# end

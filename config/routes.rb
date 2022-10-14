# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'
  resources :posts, only: :index
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  namespace :v1 do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      registrations: 'v1/auth/registrations'
    }

    scope shallow_prefix: 'user' do
      resources :hotels do
        resources :reviews, shallow: true
      end
    end

    scope '/reviews/:review_id' do
      resource :helpfulnesses, only: %i[create destroy]
    end

    get 'images', to: 'images#signed_url'
    post 'images/hotel', to: 'images#save_hotel_key'
    post 'images/user', to: 'images#save_user_key'

    namespace :auth do
      resources :sessions, only: %i[index]
    end
  end
end

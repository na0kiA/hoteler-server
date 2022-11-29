# frozen_string_literal: true

Rails.application.routes.draw do
  resources :posts, only: :index
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"
  namespace :v1 do
    root to: "home#index", as: :home

    mount_devise_token_auth_for "User", at: "auth", controllers: {
      registrations: "v1/auth/registrations"
    }

    scope shallow_prefix: "user" do
      resources :hotels do
        resources :reviews, shallow: true
        resources :images, only: %i[index show create], controller: "hotel_images"
        resources :days, only: %i[index]
        resource :favorites, only: %i[create destroy]
      end
    end

    scope "/days/:day_id" do
      resources :rest_rates, only: %i[create update destroy]
      resources :stay_rates, only: %i[create update destroy]
      resources :special_periods, only: %i[create update destroy]
    end

    scope "/reviews/:review_id" do
      resource :helpfulnesses, only: %i[create destroy]
    end

    resources :users, only: %i[index show] do
      member do
        resources :favorites, only: %i[index], controller: "user_favorites"
      end
    end

    resources :notifications, only: %i[index]

    resources :images, only: %i[index]

    namespace :auth do
      resources :sessions, only: %i[index]
    end
  end
end

# frozen_string_literal: true

Rails.application.routes.draw do
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"

  namespace :v1 do
    resources :healthcheck, only: %i[index]
    resources :test, only: %i[index]

    mount_devise_token_auth_for "User", at: "auth", controllers: {
      registrations: "v1/auth/registrations",
      passwords: "v1/auth/passwords"
    }

    scope shallow_prefix: "user" do
      resources :hotels do
        resources :reviews, shallow: true
        resources :images, only: %i[index show create], controller: "hotel_images"
        resources :days, only: %i[index]
        resource :hotel_facilities, only: %i[update]
        resource :favorites, only: %i[create destroy show]
      end
    end

    scope "/days/:day_id" do
      resources :rest_rates, except: %i[show]
      resources :stay_rates, except: %i[show]
      resources :special_periods, except: %i[show]
    end

    scope "/reviews/:review_id" do
      resource :helpfulnesses, only: %i[create destroy show]
    end

    resources :users, only: %i[index show] do
      member do
        resources :favorites, only: %i[index], controller: "user_favorites"
      end
    end

    resources :notifications, only: %i[index]
    resources :notification_or_not, only: %i[index]

    resources :search, only: %i[index] do
      resources :room_status, only: %i[index]
      resources :price, only: %i[index]
      resources :location, only: %i[index]
    end

    resources :images, only: %i[index]

    namespace :auth do
      resources :sessions, only: %i[index]
    end
  end
end

Rails.application.routes.draw do
  resources :posts, only: :index
  namespace :v1 do
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      registrations: 'v1/auth/registrations'
    }
    resources :hotels
    namespace :auth do
      resources :sessions, only: %i[index]
    end
  end
end

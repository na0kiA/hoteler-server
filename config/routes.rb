Rails.application.routes.draw do
  resources :posts, only: :index
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  namespace :v1 do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      registrations: 'v1/auth/registrations'
    }
    resources :hotels

    get 'presigned-url', to: 's3#s3_direct_post'

    namespace :auth do
      resources :sessions, only: %i[index]
    end
  end
end

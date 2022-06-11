Rails.application.routes.draw do
  namespace :v1 do
    mount_devise_token_auth_for 'User', at: 'auth'
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end
  resources :posts, only: :index
end

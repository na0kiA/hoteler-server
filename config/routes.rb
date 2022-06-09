Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :posts, only: :index
end

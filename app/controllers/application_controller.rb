class ApplicationController < ActionController::Base
  # rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  include DeviseTokenAuth::Concerns::SetUserByToken
  skip_before_action :verify_authenticity_token, if: :devise_controller?, raise: false

  helper_method :current_user, :user_signed_in?

  # def record_not_found
  #   render plain: "404 Not Found", status: :not_found
  # end
end

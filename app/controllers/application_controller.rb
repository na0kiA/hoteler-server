class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  include DeviseTokenAuth::Concerns::SetUserByToken
  skip_before_action :verify_authenticity_token

  helper_method :current_user, :user_signed_in?

  private

  def record_not_found
    render json: { errors: '404 not found' }, status: :not_found
  end
end

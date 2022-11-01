# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::RoutingError, with: :path_not_found

  include DeviseTokenAuth::Concerns::SetUserByToken
  skip_before_action :verify_authenticity_token

  helper_method :current_user, :user_signed_in?

  private

    def record_not_found
      render json: { errors: { title: '404 NOT FOUND', body: '既に削除されてあるか、存在しないページです' } }, status: :not_found
    end

    def path_not_found
      render json: { errors: '存在しないページです' }, status: :not_found
    end

    def render_json_bad_request_with_custom_errors(title:, body:)
      render json: { errors: { title:, body: } }, status: :bad_request
    end
end

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ActionController::RequestForgeryProtection
  include DeviseTokenAuth::Concerns::SetUserByToken

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::RoutingError, with: :path_not_found
  rescue_from ActionController::Redirecting::UnsafeRedirectError, with: :allow_redirect

  before_action :convert_to_snake_case_params

  # CSRF対策をすること
  skip_before_action :verify_authenticity_token

  before_action :set_csrf_token_header
  helper_method :current_user, :user_signed_in?

  private

    def set_csrf_token_header
      response.set_header("X-CSRF-Token", form_authenticity_token)
    end

    def allow_redirect
      redirect_to(params[:redirect_url], allow_other_host: true)
    end

    def convert_to_snake_case_params
      params.deep_transform_keys!(&:underscore)
    end

    def record_not_found
      render json: { errors: { title: "404 NOT FOUND", body: "既に削除されてあるか、存在しないページです" } }, status: :not_found
    end

    def search_not_found
      render json: { errors: { title: "404 NOT FOUND", body: "存在しない検索対象です" } }, status: :not_found
    end

    def path_not_found
      render json: { errors: "存在しないページです" }, status: :not_found
    end

    def render_json_bad_request_with_custom_errors(title:, body:)
      render json: { errors: { title:, body: } }, status: :bad_request
    end

    def render_json_forbidden_with_custom_errors(message:)
      render json: { errors: { message: } }, status: :forbidden
    end
end

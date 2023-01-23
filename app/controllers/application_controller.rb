# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # include ActionController::Cookies
  # include ActionController::RequestForgeryProtection
  include DeviseTokenAuth::Concerns::SetUserByToken

  # protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::RoutingError, with: :path_not_found
  rescue_from ActionController::Redirecting::UnsafeRedirectError, with: :unsafe_path

  before_action :convert_to_snake_case_params
  

  skip_before_action :verify_authenticity_token

  helper_method :current_user, :user_signed_in?

  private

  # def set_csrf_token
  #   response.set_header('x-csrf-token', form_authenticity_token)
    # response.headers['Set-Cookie'] = 'Secure;SameSite=None'
  # end

  # def set_csrf_token
  #   cookies['CSRF-TOKEN'] = {
  #     domain: 'jp.ngrok.io', 
  #     value: form_authenticity_token,
  #     same_site: "None",
  #     secure: true
  #   }
  # end  
  
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

    def unsafe_path
      render json: { errors: { title: "404 NOT FOUND", body: "安全ではないURLです。URLの打ち間違いがないか確認してください" } }, status: :not_found
    end
end

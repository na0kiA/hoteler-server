# frozen_string_literal: true

module V1
  module Auth
    class SessionsController < ApplicationController
      after_action :set_csrf_token

      def index
        if current_v1_user
          render json: { is_login: true, data: current_v1_user, has_hotel: current_v1_user.hotels.present?}
        else
          render json: { is_login: false, message: "ユーザーが存在しません" }
        end
      end

      private

        def set_csrf_token
          response.set_header('x-csrf-token', form_authenticity_token)
        end
    end
  end
end

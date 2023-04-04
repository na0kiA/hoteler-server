# frozen_string_literal: true

module V1
  module Auth
    class SessionsController < ApplicationController
      def index
        if current_v1_user
          # set_csrf_token
          render json: { is_login: true, data: current_v1_user, has_hotel: current_v1_user.hotels.present?, notifications_count: current_v1_user.notifications.where(read: false).count }
        else
          render json: { is_login: false, message: "ユーザーが存在しません" }
        end
      end
    end
  end
end

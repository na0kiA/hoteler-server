# ログイン状態確認用コントローラー
module V1
  module Auth
    class SessionsController < ApiController
      def index
        if current_api_v1_user
          render json: { is_login: true, data: current_api_v1_user }
        else
          render json: { is_login: false, message: "ユーザーが存在しません" }
        end
      end
    end
  end
end

# frozen_string_literal: true

module V1
  module Auth
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      before_action :prohibit_chages_to_guest_use, only: %i[update destroy]

      private

        def sign_up_params
          params.permit(:name, :email, :image, :password, :password_confirmation)
        end

        def prohibit_chages_to_guest_user
          render_json_bad_request_with_custom_errors("変更できません。", "ゲストユーザーの情報は変更できません。") if current_v1_user.uid == "iam_guest_user@eripo.net"
        end

        def account_update_params
          params.permit(:name, :email, :image)
        end
    end
  end
end

# frozen_string_literal: true

module V1
  module Auth
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      before_action :prohibit_chages_to_guest_user, only: %i[destroy]

      private

        def sign_up_params
          params.permit(:name, :email, :image, :password, :password_confirmation)
        end

        def prohibit_chages_to_guest_user
          render_json_forbidden_with_custom_errors(message: "ゲストユーザーは削除できません。") if current_v1_user&.uid == "na0ki199823@gmail.com"
        end

        def account_update_params
          params.permit(:name, :email, :image)
        end
    end
  end
end

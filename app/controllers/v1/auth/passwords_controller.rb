# frozen_string_literal: true

class V1::Auth::PasswordsController < DeviseTokenAuth::PasswordsController
  before_action :prohibit_chages_to_guest_user, only: %i[update create edit]

  private

    def prohibit_chages_to_guest_user
      render_json_forbidden_with_custom_errors(message: "ゲストユーザーのパスワードは変更できません。") if params[:email] == "iam_guest_user@eripo.net" || current_v1_user&.uid == "iam_guest_user@eripo.net"
    end
end

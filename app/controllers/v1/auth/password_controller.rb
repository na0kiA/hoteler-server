# frozen_string_literal: true

class V1::Auth::PasswordController < ApplicationController
  before_action :prohibit_chages_to_guest_use, only: %i[update create edit]

  private

  def prohibit_chages_to_guest_user
    render_json_bad_request_with_custom_errors("変更できません。", "ゲストユーザーのパスワードは変更できません。") if current_v1_user.uid == "iam_guest_user@eripo.net"
  end
end

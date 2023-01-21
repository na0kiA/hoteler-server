# frozen_string_literal: true

class V1::UsersController < ApplicationController
  before_action :authenticate_v1_user!

  def show
    user = User.find_by(id: params[:id])
    p current_v1_user
    if user.present?
      render json: user, serializer: UserShowSerializer, current_user: current_v1_user
    else
      record_not_found
    end
  end
end

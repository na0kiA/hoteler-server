# frozen_string_literal: true

class V1::UsersController < ApplicationController
  def show
    user = User.find_by(id: params[:id])
    if user.present?
      render json: user, serializer: UserShowSerializer
    else
      record_not_found
    end
  end
end

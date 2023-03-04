# frozen_string_literal: true

class V1::NotificationOrNotController < ApplicationController
  before_action :authenticate_v1_user!

  def index
    notifications = current_v1_user.notifications
    if notifications.blank?
      render json: []
    else
      not_read_notification = notifications.where(read: false).count
      render json: not_read_notification
    end
  end
end

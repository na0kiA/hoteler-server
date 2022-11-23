# frozen_string_literal: true

class V1::NotificationsController < ApplicationController
  before_action :authenticate_v1_user!

  def index
    notifications = current_v1_user.notifications
    if notifications.blank?
      render json: { title: 'まだ通知はありません。' }
    else
      Notification.update_read(notifications)
      notifications.reload
      render json: notifications, each_serializer: NotificationSerializer
    end
  end
end

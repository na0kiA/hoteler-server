# frozen_string_literal: true

class Notification < ApplicationRecord
  default_scope -> { order(created_at: :desc) }

  belongs_to :user
  belongs_to :hotel
  belongs_to :sender, class_name: "User"

  enum kind: {
    came_reviews: 0,
    came_favorites: 1,
    hotel_updates: 2
  }

  validates :message, presence: true, length: { maximum: 30, minimum: 2 }

  def self.update_read(notifications)
    notifications.where(read: false).find_each do |notification|
      notification.update!(read: true)
    end
  end
end

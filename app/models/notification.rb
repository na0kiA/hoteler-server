# frozen_string_literal: true

class Notification < ApplicationRecord
  default_scope -> { order(created_at: :desc) }

  belongs_to :user
  belongs_to :hotel
  belongs_to :sender, class_name: 'User'

  enum kind: {
    came_reviews: 0,
    came_favorites: 1,
    hotel_updates: 2
  }
end

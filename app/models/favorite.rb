# frozen_string_literal: true

class Favorite < ApplicationRecord
  default_scope -> { order(created_at: :desc) }

  belongs_to :user
  belongs_to :hotel
  counter_culture :hotel
end

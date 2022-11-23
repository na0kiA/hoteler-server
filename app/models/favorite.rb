# frozen_string_literal: true

class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :hotel
  counter_culture :hotel
end

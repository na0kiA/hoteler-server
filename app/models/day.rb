# frozen_string_literal: true

class Day < ApplicationRecord
  belongs_to :hotel
  has_many :rest_rates, dependent: :destroy
  has_many :special_periods, dependent: :destroy

  validates :day, presence: true, length: { maximum: 10 }
end

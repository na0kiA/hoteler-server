# frozen_string_literal: true

class Day < ApplicationRecord
  belongs_to :hotel
  has_many :rest_rates, dependent: :destroy
  has_many :special_periods, dependent: :destroy

  validates :day, presence: true, length: { maximum: 10 }

  def save
    day.map do |day_of_the_week|
      Day.create!(day: day_of_the_week, hotel_id:)
    end
  end
end

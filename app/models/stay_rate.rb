# frozen_string_literal: true

class StayRate < ApplicationRecord
  belongs_to :day
  has_one :hotel, through: :day

  with_options presence: true do
    validates :plan, length: { maximum: 10 }, invalid_words: true
    validates :rate, numericality: { less_than: 10_000_000 }
    validates :start_time
    validates :end_time
  end
end

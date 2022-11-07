# frozen_string_literal: true

class RestRate < ApplicationRecord
  belongs_to :day

  with_options presence: true do
    validates :plan, length: { maximum: 10 }, invalid_words: true
    validates :rate, numericality: { less_than: 10_000_000 }
    validates :first_time
    validates :last_time
  end
end

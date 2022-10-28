# frozen_string_literal: true

class SpecialPeriod < ApplicationRecord
  belongs_to :day
  enum :period, { golden_week: 0, obon: 1, the_new_years_holiday: 2 }

  validates :start_date, presence: true
  validates :end_date, presence: true
end

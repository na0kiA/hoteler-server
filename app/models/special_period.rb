# frozen_string_literal: true

class SpecialPeriod < ApplicationRecord
  # include LiberalEnum

  belongs_to :day

  enum :period, { golden_week: 0, obon: 1, the_new_years_holiday: 2 }
  # liberal_enum :period

  validates :period, inclusion: { in: SpecialPeriod.periods.keys }
  validates :start_date, presence: true
  validates :end_date, presence: true
end

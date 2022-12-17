# frozen_string_literal: true

class SpecialPeriod < ApplicationRecord
  belongs_to :day

  enum :period, { golden_week: 0, obon: 1, the_new_years_holiday: 2 }, prefix: true

  validates :period, inclusion: { in: SpecialPeriod.periods.keys }
  validates :start_date, presence: true
  validates :end_date, presence: true

  def self.check_that_today_is_a_special_period?(hotel:)
    special_weeks = hotel.special_periods.pluck(:start_date, :end_date).flatten
    (special_weeks[0]..special_weeks[1]).cover?(Date.current) || (special_weeks[2]..special_weeks[3]).cover?(Date.current) || (special_weeks[4]..special_weeks[5]).cover?(Date.current)
  end

  def self.check_that_today_is_a_last_day_of_special_periods?(hotel:)
    end_date_list = hotel.special_periods.pluck(:end_date)

    end_date_list[0].eql?(Date.current) || end_date_list[1].eql?(Date.current) || end_date_list[2].eql?(Date.current)
  end
end

# frozen_string_literal: true

class SpecialPeriod < ApplicationRecord
  belongs_to :day

  enum :period, { golden_week: 0, obon: 1, the_new_years_holiday: 2 }, prefix: true

  validates :period, inclusion: { in: SpecialPeriod.periods.keys }
  validates :start_date, presence: true
  validates :end_date, presence: true

  def self.check_that_today_is_a_special_period?(hotel:)
    start_date_list = hotel.special_periods.pluck(:start_date)
    end_date_list = hotel.special_periods.pluck(:end_date)

    (start_date_list[0]..end_date_list[0]).cover?(Date.current) || (start_date_list[1]..end_date_list[1]).cover?(Date.current) || (start_date_list[2]..end_date_list[2]).cover?(Date.current)
  end

  def self.check_that_today_is_a_last_day_of_special_periods?(hotel:)
    end_date_list = hotel.special_periods.pluck(:end_date)

    end_date_list[0].eql?(Date.current) || end_date_list[1].eql?(Date.current) || end_date_list[2].eql?(Date.current)
  end
end

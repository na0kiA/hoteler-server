# frozen_string_literal: true

class Day < ApplicationRecord
  belongs_to :hotel
  has_many :rest_rates, dependent: :destroy
  has_many :special_periods, dependent: :destroy

  validates :day, presence: true, length: { maximum: 10 }

  scope :monday_through_thursday, -> { where(day: '月曜から木曜') }
  scope :friday, -> { where(day: '金曜') }
  scope :saturday, -> { where(day: '土曜') }
  scope :sunday, -> { where(day: '日曜') }
  scope :holiday, -> { where(day: '祝日') }
  scope :day_before_a_holiday, -> { where(day: '祝前日') }
  scope :special_day, -> { where(day: '特別期間') }

  DAYS = %w[日曜 月曜 火曜 水曜 木曜 金曜 土曜].freeze

  def self.select_a_day_of_the_week(today = Time.zone.today.wday)
    return Day.holiday if HolidayJapan.check(Date.current)
    return Day.day_before_a_holiday if HolidayJapan.check(Date.current.tomorrow)
    return Day.monday_through_thursday if DAYS[today].start_with?('月曜', '火曜', '水曜', '木曜')
    return Day.where(day: DAYS[today]) if DAYS[today].start_with?('金曜', '土曜', '日曜')
  end
end

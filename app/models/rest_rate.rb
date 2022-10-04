# frozen_string_literal: true

class RestRate < ApplicationRecord
  belongs_to :day

  with_options presence: true do
    validates :plan, length: { maximum: 10 }, invalid_words: true
    validates :rate, numericality: { less_than: 10_000_000 }
    validates :first_time
    validates :last_time
  end

  DAYS = ['日曜', '月曜', '火曜', '水曜', '木曜', "金
    曜", '土曜'].freeze

    # [*first..23, *0..last].include?(now)

  # 今の曜日と時間から、ホテルの休憩で一番安いプランと料金を返す
  def now_rest_rate
    if now_include_first_rest_time? && now_include_last_rest_time?
      RestRate.where(id: today_rest_rate_list).pluck(:plan)
      RestRate.where(id: today_rest_rate_list).pluck(:rate)
    end
  end

    private

    def now_include_first_rest_time?(now = convert_hour(time: Time.current))
      first_rest_time_array.map do |first_time|
        [*first_time..23].include?(now)
      end
    end

    def now_include_last_rest_time?(now = convert_hour(time: Time.current))
      last_rest_time_array.map do |last_time|
        [*0..last_time].include?(now)
      end
    end

    def rest_time_array
      today_rest_rate_list.pluck(:first_time, :last_time, :id).map do |time|
        first_time_array = convert_hour(time: time[0])
        last_time_array = convert_hour(time: time[1])
      end
    end
    
    def convert_hour(time:)
        (I18n.l time, format: :hours).to_i
    end

    def today_rest_rate_list(today = Time.zone.today.wday)
      day_ids = if DAYS[today].start_with?('月曜', '火曜', '水曜', '木曜')
                  Day.where(day: '月曜から木曜').pluck(:id)
                else
                  Day.where(day: DAYS[today]).pluck(:id)
                end
      RestRate.where(day_id: day_ids)
    end
end

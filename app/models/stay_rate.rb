# frozen_string_literal: true

class StayRate < ApplicationRecord
  include ConvertAtHour

  belongs_to :day

  with_options presence: true do
    validates :plan, length: { maximum: 10 }, invalid_words: true
    validates :rate, numericality: { less_than: 10_000_000 }
    validates :start_time
    validates :end_time
  end

  scope :time, -> { where(day: '金曜') }

  MAX_TIME = 24

  class << self
    def select_stay_service_from_the_current_time(stay_rates:)
      stay_rates.pluck(:start_time, :end_time, :id)&.map do |val|
        arr = []
        arr << val[2] << if the_time_now_is_after_6_am?(val[0]) && aftet_business_hours(start_time: val[0])
                           [*convert_at_hour(Time.current)...convert_at_hour(val[0])].length
                         else
                          MAX_TIME
                         end
      end
    end
    # {:plan=>"素泊まり", :rate=>10980, :start_time=>0, :end_time=>9}

    def select_the_next_start_stay_id(stay_rates:)
      select_stay_service_from_the_current_time(stay_rates:).min_by { |a| a[1] }.first
    end

    # start_timeに今の時刻が含まれていない場合
    def aftet_business_hours(start_time:)
      [*convert_at_hour(start_time)..23].none?(convert_at_hour(Time.current))
    end

  # ホテルの締め時間は朝6時なので,6時以降に表示する宿泊プランは今日の宿泊プランの必要がある
    def the_time_now_is_after_6_am?(time = Time.current)
      convert_at_hour(time) >= 6
    end
  end
end

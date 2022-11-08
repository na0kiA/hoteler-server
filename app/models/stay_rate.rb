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

  class << self

    def select_stay_service_from_the_current_time(stay_rates:)
        stay_rates.pluck(:start_time, :end_time, :id)&.map do |val|
          arr = []
          arr << val[2] << [*convert_at_hour(Time.current)...convert_at_hour(val[0])].length
        end
      end

    def select_the_next_start_stay_id(stay_rates:)
      p select_stay_service_from_the_current_time(stay_rates:)
      select_stay_service_from_the_current_time(stay_rates:).min_by { |a| a[1] }.first
    end

  # ホテルの締め時間は朝6時なので,6時以降に表示する宿泊プランは今日の宿泊プランの必要がある
    def the_time_now_is_after_6_am?
      convert_at_hour(Time.current) >= 6
    end

  end
end
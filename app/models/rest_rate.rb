# frozen_string_literal: true

class RestRate < ApplicationRecord
  belongs_to :day

  with_options presence: true do
    validates :plan, length: { maximum: 10 }, invalid_words: true
    validates :rate, numericality: { less_than: 10_000_000 }
    validates :first_time
    validates :last_time
  end

  DAYS = %w[日曜 月曜 火曜 水曜 木曜 金曜 土曜].freeze

    # rest_ratesにbool値をつけるかどうか
    # enumを追加するかどうか
    # 営業時間内のrest_ratesの中からplanが最安のものを表示する
  # 今の曜日と時間から、ホテルの休憩で一番安いプランと料金を返す
  # 営業時間外(nil)の場合は"営業時間外です"をJSONで表示する
  def now_rest_rate
    during_business_hours
    # outside_business_hours
  end

  def during_business_hours
    # RestRate.where(id: rest_time_array.map(&:present?))
    RestRate.where(id: can_take_rest_array.select { |num| num.to_s.match?(/^[0-9]+$/) })
  end

  def outside_business_hours
    RestRate.where(id: can_take_rest_array.reject { |num| num.to_s.match?(/^[0-9]+$/)})
  end

  private

    def can_take_rest_array
      today_rest_rate_list.pluck(:first_time, :last_time, :id, :plan).map do |val|
         if val[3].include?("深夜休憩")
          can_take_a_midnight_rest_or_not(first_time: val[0], last_time: val[1], ids: val[2])
        else
          can_take_a_rest_or_not(first_time: val[0], last_time: val[1], ids: val[2]) 
        end
      end
    end

    def can_take_a_rest_or_not(first_time:, last_time:, ids:)
      at_now_includes_rest_time?(first_time: convert_at_hour(time: first_time), last_time: convert_at_hour(time: last_time)) ? ids : "#{ids}は営業時間外です"
    end

    def can_take_a_midnight_rest_or_not(first_time:, last_time:, ids:)
      at_now_includes_midnight_rest_time?(first_time: convert_at_hour(time: first_time), last_time: convert_at_hour(time: last_time)) ? ids : "#{ids}は営業時間外です" 
    end

    def at_now_includes_rest_time?(first_time:, last_time:)
      [*first_time..23, *0..last_time].include?(convert_at_hour(time: Time.current))
    end

    def at_now_includes_midnight_rest_time?(first_time:, last_time:)
      [*first_time..last_time].include?(convert_at_hour(time: Time.current)) 
    end

    def convert_at_hour(time:)
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

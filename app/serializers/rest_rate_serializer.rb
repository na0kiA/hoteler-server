# frozen_string_literal: true

require 'holiday_japan'

class RestRateSerializer < ActiveModel::Serializer
  attributes :plan, :rate, :first_time, :last_time, :day_id, :holiday

  DAYS = %w[日曜 月曜 火曜 水曜 木曜 金曜 土曜].freeze

  def holiday
    HolidayJapan.hash_year(2022)
  end
  # 今の曜日と時間から、表示する休憩料金を返す

  def can_take_rest_array
    today_day_of_the_week_rest_rate_list.pluck(:first_time, :last_time, :id, :plan)&.map do |val|
      if val[3].start_with?('深夜休憩')
        can_take_a_midnight_rest_or_not(first_time: val[0], last_time: val[1], ids: val[2])
      else
        can_take_a_normal_rest_or_not(first_time: val[0], last_time: val[1], ids: val[2])
      end
    end
  end

  def can_take_a_normal_rest_or_not(first_time:, last_time:, ids:)
    at_now_includes_normal_rest_time?(first_time: convert_at_hour(time: first_time), last_time: convert_at_hour(time: last_time)) ? ids : "#{ids}は営業時間外です"
  end

  def can_take_a_midnight_rest_or_not(first_time:, last_time:, ids:)
    at_now_includes_midnight_rest_time?(first_time: convert_at_hour(time: first_time), last_time: convert_at_hour(time: last_time)) ? ids : "#{ids}は営業時間外です"
  end

  # サービス終了は〇〇時59分までなので範囲オブジェクトは...を使用
  def at_now_includes_normal_rest_time?(first_time:, last_time:)
    [*first_time..23, *0...last_time].include?(convert_at_hour(time: Time.current))
  end

  def at_now_includes_midnight_rest_time?(first_time:, last_time:)
    [*first_time...last_time].include?(convert_at_hour(time: Time.current))
  end

  def convert_at_hour(time:)
    (I18n.l time, format: :hours).to_i
  end

  def today_day_of_the_week_rest_rate_list(today = Time.zone.today.wday)
    day_id_array = if DAYS[today].start_with?('月曜', '火曜', '水曜', '木曜')
                     Day.where(day: '月曜から木曜', hotel_id: object.day.hotel_id).pluck(:id)
                   else
                     Day.where(day: DAYS[today], hotel_id: object.day.hotel_id).pluck(:id)
                   end
    RestRate.where(day_id: day_id_array)
  end
end

# frozen_string_literal: true

class DaySerializer < ActiveModel::Serializer
  # attributes :id, :day, :hotel_id
  attributes :day

  # DAYS = %w[日曜 月曜 火曜 水曜 木曜 金曜 土曜].freeze

  # def day(today = Time.zone.today.wday)
  #   if DAYS[today].start_with?('月曜', '火曜', '水曜', '木曜')
  #     Day.where(day: '月曜から木曜', hotel_id: object.hotel_id).pick(:day)
  #   else
  #      Day.where(day: DAYS[today], hotel_id: object.hotel_id).pluck(:day)
  #   end
  # end

  # private

  #   #今日の曜日にあてはまる休憩料金を配列で取得
  #   def today_rest_rate_list(today = Time.zone.today.wday)
  #     day_ids = if DAYS[today].start_with?('月曜', '火曜', '水曜', '木曜')
  #                 Day.where(day: '月曜から木曜').pluck(:id)
  #               else
  #                 Day.where(day: DAYS[today]).pluck(:id)
  #               end
  #     RestRate.where(day_id: day_ids)
  #   end
end

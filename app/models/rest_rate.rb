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

    # rest_ratesにbool値をつけるかどうか
    # enumを追加するかどうか
    #営業時間内のrest_ratesの中からplanが最安のものを表示する
  # 今の曜日と時間から、ホテルの休憩で一番安いプランと料金を返す
  # 営業時間外(nil)の場合は"営業時間外です"をJSONで表示する
  def now_rest_rate
    # during_business_hours
    outside_business_hours
  end

  def during_business_hours
    RestRate.where(id: rest_time_array.select{|num| num.to_s =~ /^[0-9]+$/})
  end

  def outside_business_hours
    RestRate.where(id: rest_time_array.reject{|num| num.to_s =~ /^[0-9]+$/})
  end

  private

    def rest_time_array
      today_rest_rate_list.pluck(:first_time, :last_time, :id).map { |val| return_ids_or_nil(first_time: val[0], last_time: val[1], ids: val[2]) }
    end

    def return_ids_or_nil(first_time:, last_time:, ids:)
      now_business_hour?(first_time: convert_hour(time: first_time), last_time: convert_hour(time: last_time)) ? ids : "#{ids}は営業時間外です"
    end

    def now_business_hour?(first_time:, last_time:)
      [*first_time..23, *0..last_time].include?(convert_hour(time: Time.current))
    end

    def convert_hour(time:)
      (I18n.l time, format: :hours).to_i
    end

    # def today_rest_rate_list(today = Time.zone.today.wday)
    #   day_ids = if DAYS[today].start_with?('月曜', '火曜', '水曜', '木曜')
    #               Day.where(day: '月曜から木曜').pluck(:id)
    #             else
    #               Day.where(day: DAYS[today]).pluck(:id)
    #             end
    #   RestRate.where(day_id: day_ids)
    # end
    def today_rest_rate_list
      RestRate.includes(:day).where(day_id: Day.where(day: "金曜"))
    end
end

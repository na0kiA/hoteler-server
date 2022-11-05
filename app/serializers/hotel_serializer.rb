# frozen_string_literal: true

require 'holiday_japan'

class HotelSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :content,
             :average_rating,
             :reviews_count,
             :hotel_images,
             :day_of_the_week,
             :rest_rates

  def hotel_images
    ActiveModelSerializers::SerializableResource.new(
      object.hotel_images,
      each_serializer: HotelImageSerializer,
      adapter: :attributes
    ).serializable_hash
  end

  def day_of_the_week
    ActiveModelSerializers::SerializableResource.new(
      select_todays_day_of_the_week,
      each_serializer: DaySerializer,
      adapter: :attributes
    ).serializable_hash
  end

  def rest_rates
    return '営業時間外です' if during_business_hours_list.blank?

    ActiveModelSerializers::SerializableResource.new(
      filtered_cheapest_rest_rate,
      each_serializer: RestRateSerializer,
      adapter: :attributes
    ).serializable_hash
  end

  DAYS = %w[日曜 月曜 火曜 水曜 木曜 金曜 土曜].freeze

  private

    def filtered_cheapest_rest_rate
      object.rest_rates.where(id: during_business_hours_list.ids).where(rate: during_business_hours_list.pluck(:rate).max)
    end

    # def render_json_after_hours_notice
    #   if
    # end

    def during_business_hours_list
      RestRate.where(id: can_take_rest_array.select(&:present?))
    end

    def can_take_rest_array
      extract_today_rest_rate_list.pluck(:first_time, :last_time, :id, :plan)&.map do |val|
        if val[3].start_with?('深夜休憩')
          can_take_a_midnight_rest_or_not(first_time: val[0], last_time: val[1], ids: val[2])
        else
          can_take_a_daytime_rest_or_not(first_time: val[0], last_time: val[1], ids: val[2])
        end
      end
    end

    def can_take_a_daytime_rest_or_not(first_time:, last_time:, ids:)
      at_now_includes_daytime_rest_time?(first_time: convert_at_hour(time: first_time), last_time: convert_at_hour(time: last_time)) ? ids : nil
    end

    def can_take_a_midnight_rest_or_not(first_time:, last_time:, ids:)
      at_now_includes_midnight_rest_time?(first_time: convert_at_hour(time: first_time), last_time: convert_at_hour(time: last_time)) ? ids : nil
    end

  # サービス終了は〇〇時59分までなので範囲オブジェクトは...を使用
    def at_now_includes_daytime_rest_time?(first_time:, last_time:)
      [*first_time..23, *0...last_time].include?(convert_at_hour(time: Time.current))
    end

    def at_now_includes_midnight_rest_time?(first_time:, last_time:)
      [*first_time...last_time].include?(convert_at_hour(time: Time.current))
    end

    # def today_includes_a_special_period?(start_date = object.special_periods.start_date, end_date:)
    #   [*(I18n.l start_date)..(I18n.l end_date)].include?((I18n.l Date.current))
    # end

    def convert_at_hour(time:)
      (I18n.l time, format: :hours).to_i
    end

    def select_todays_day_of_the_week(today = Time.zone.today.wday, hotel_id = object.id)
      return Day.where(day: '祝日', hotel_id:) if HolidayJapan.check(Date.current)
      return Day.where(day: '祝前日', hotel_id:) if HolidayJapan.check(Date.current.tomorrow)
      return Day.where(day: '月曜から木曜', hotel_id:) if DAYS[today].start_with?('月曜', '火曜', '水曜', '木曜')
      return Day.where(day: DAYS[today], hotel_id:) if DAYS[today].start_with?('金曜', '土曜', '日曜')
    end

    # def check_today_is_special_periods_or_not(today = Time.zone.today, hotel_id = object.id)
    #   if object.special_periods.start_date
    #     Day.where(day: '特別期間', hotel_id:)
    #   end
    # end

    def extract_today_rest_rate_list
      RestRate.where(day_id: select_todays_day_of_the_week.ids)
    end
end

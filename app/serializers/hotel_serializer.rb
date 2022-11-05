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
      select_a_day,
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
      object.rest_rates.where(id: during_business_hours_list.ids).where(rate: during_business_hours_list.pluck(:rate).min)
    end

    def during_business_hours_list
      RestRate.where(id: can_take_service_list.select(&:present?))
      # StayRate.where(id: can_take_service_list.select(&:present?))
    end

    def can_take_service_list
      extract_today_rate_list.pluck(:first_time, :last_time, :id)&.map do |val|
        # 深夜休憩や素泊まりプランなど0時から5時に始まるサービスが利用できるかどうか調べている。
        if convert_at_hour(time: val[0]) >= 0 && convert_at_hour(time: val[0]) <= 5
          can_take_a_midnight_service_or_not(first_time: val[0], last_time: val[1], ids: val[2])
        else
          can_take_a_daytime_service_or_not(first_time: val[0], last_time: val[1], ids: val[2])
        end
      end
    end

    # サービス終了時刻は〇〇時59分までなので範囲オブジェクトは...を使用
    # 夜21時から翌朝9時までのサービスに対応するために[first..23, *0...last]のようにして今が営業時間かどうか調べている
    def can_take_a_daytime_service_or_not(first_time:, last_time:, ids:)
      [*convert_at_hour(time: first_time)..23, *0...convert_at_hour(time: last_time)].include?(convert_at_hour(time: Time.current)) ? ids : nil
    end

    def can_take_a_midnight_service_or_not(first_time:, last_time:, ids:)
      [*convert_at_hour(time: first_time)...convert_at_hour(time: last_time)].include?(convert_at_hour(time: Time.current)) ? ids : nil
    end

    def convert_at_hour(time:)
      (I18n.l time, format: :hours).to_i
    end

    def select_a_day
      return Day.special_day.where(hotel_id: object.id) if SpecialPeriod.check_today_is_a_special_period?(hotel: object)

      Day.select_day_of_the_week.where(hotel_id: object.id)
    end

    def extract_today_rate_list
      RestRate.where(day_id: select_a_day.ids)
      # StayRate.where(day_id: select_todays_day_of_the_week.ids)
    end
end

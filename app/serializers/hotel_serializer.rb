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
    return '営業時間外です' if can_take_services_list.all?(&:nil?)

    ActiveModelSerializers::SerializableResource.new(
      filtered_cheapest_a_rest_rate,
      each_serializer: RestRateSerializer,
      adapter: :attributes
    ).serializable_hash
  end

  DAYS = %w[日曜 月曜 火曜 水曜 木曜 金曜 土曜].freeze

  private

    def filtered_cheapest_a_rest_rate
      object.rest_rates.where(id: during_business_hours_list.pluck(:id)).where(rate: during_business_hours_list.pluck(:rate).min)
    end

    def during_business_hours_list
      can_take_services_list.select(&:present?)
    end

    def can_take_services_list
      BusinessHour.take_services_list(today_rate_list: extract_today_services_rate_list)
    end

    def select_a_day
      return Day.special_day.where(hotel_id: object.id) if SpecialPeriod.check_today_is_a_special_period?(hotel: object)

      Day.select_a_day_of_the_week.where(hotel_id: object.id)
    end

    def extract_today_services_rate_list
      RestRate.where(day_id: select_a_day.ids)
    end
end

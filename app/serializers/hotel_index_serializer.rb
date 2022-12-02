# frozen_string_literal: true

class HotelIndexSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :content,
             :full,
             :average_rating,
             :reviews_count,
             :hotel_images,
             :day_of_the_week,
             :rest_rates,
             :stay_rates

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
    return "営業時間外です" if take_the_rest_rate.blank?

    ActiveModelSerializers::SerializableResource.new(
      take_the_rest_rate,
      each_serializer: RestRateSerializer,
      adapter: :attributes
    ).serializable_hash
  end

  def stay_rates
    ActiveModelSerializers::SerializableResource.new(
      take_the_stay_rate,
      each_serializer: StayRateSerializer,
      adapter: :attributes
    ).serializable_hash
  end

  def take_the_rest_rate
    RestBusinessHour.new(date: object.rest_rates.where(day_id: select_a_day.ids)).extract_the_rest_rate
  end

  def take_the_stay_rate
    if SpecialPeriod.check_that_today_is_a_last_day_of_special_periods?(hotel: object)
      StayBusinessHour.new(stay_rates_of_the_hotel: object.stay_rates.where(day_id: Day.select_a_day_of_the_week.where(hotel_id: object.id).ids)).extract_the_stay_rate
    else
      StayBusinessHour.new(stay_rates_of_the_hotel: object.stay_rates.where(day_id: select_a_day.ids)).extract_the_stay_rate
    end
  end

  def select_a_day
    # 特別期間は最終日も含んで抽出している
    if SpecialPeriod.check_that_today_is_a_special_period?(hotel: object)
      Day.special_day.where(hotel_id: object.id)
    else
      Day.select_a_day_of_the_week.where(hotel_id: object.id)
    end
  end
end

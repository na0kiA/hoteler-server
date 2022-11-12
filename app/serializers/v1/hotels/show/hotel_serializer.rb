# frozen_string_literal: true

class HotelSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :content,
             :average_rating,
             :reviews_count,
             :hotel_images,
             :day_of_the_week

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

  def select_a_day
    return Day.special_day.where(hotel_id: object.id) if SpecialPeriod.check_that_today_is_a_special_period?(hotel: object)

    Day.select_a_day_of_the_week.where(hotel_id: object.id)
  end
end

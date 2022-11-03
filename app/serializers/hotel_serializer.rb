# frozen_string_literal: true

class HotelSerializer < ActiveModel::Serializer
  attributes :id, :name, :content, :average_rating, :reviews_count, :hotel_images, :days, :rest_rates

  def hotel_images
    ActiveModelSerializers::SerializableResource.new(
      object.hotel_images,
      each_serializer: HotelImageSerializer
    )
  end

  def days
    ActiveModelSerializers::SerializableResource.new(
      object.days,
      each_serializer: DaySerializer
    )
  end

  def rest_rates
    ActiveModelSerializers::SerializableResource.new(
      object.rest_rates,
      each_serializer: RestRateSerializer
    )
  end
end

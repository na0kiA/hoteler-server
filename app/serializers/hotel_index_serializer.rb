# frozen_string_literal: true

class HotelIndexSerializer < ActiveModel::Serializer
  attributes :name,
             :full_address,
             :full,
             :average_rating,
             :reviews_count,
             :hotel_images,
             :rest_rates,
             :stay_rates,
             :id

  def hotel_images
    return "no image" if object.hotel_images.blank?

    ActiveModelSerializers::SerializableResource.new(
      object.hotel_images.first,
      serializer: HotelImageSerializer,
      adapter: :attributes
    ).serializable_hash
  end

  def full_address
    "#{object.prefecture}#{object.city}#{object.street_address}"
  end

  def rest_rates
    return "休憩は営業時間外です" if (object.rest_rates & @instance_options[:services]).blank?

    ActiveModelSerializers::SerializableResource.new(
      object.rest_rates & @instance_options[:services],
      each_serializer: RestRateSerializer,
      adapter: :attributes
    ).serializable_hash
  end

  def stay_rates
    return "宿泊プランはございません" if (object.stay_rates & @instance_options[:services]).blank?

    ActiveModelSerializers::SerializableResource.new(
      object.stay_rates & @instance_options[:services],
      each_serializer: StayRateSerializer,
      adapter: :attributes
    ).serializable_hash
  end
end

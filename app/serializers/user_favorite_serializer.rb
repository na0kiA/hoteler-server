# frozen_string_literal: true

class UserFavoriteSerializer < ActiveModel::Serializer
  attributes :id,
             :hotel_name,
             :hotel_top_image,
             :five_star_rate,
             :hotel_id,
             :hotel_full_address,
             :hotel_reviews_count

  def hotel_name
    object.hotel.name
  end

  def hotel_id
    object.hotel.id
  end

  def hotel_reviews_count
    object.hotel.reviews_count
  end

  def hotel_full_address
    "#{object.hotel.prefecture}#{object.hotel.city}#{object.hotel.street_address}"
  end

  def hotel_top_image
    return "ホテルの画像は未設定です" if object.hotel.hotel_images.blank?

    ActiveModelSerializers::SerializableResource.new(
      object.hotel.hotel_images.first,
      serializer: HotelImageSerializer,
      adapter: :attributes
    ).serializable_hash
  end

  def five_star_rate
    object.hotel.average_rating
  end
end

# frozen_string_literal: true

class HotelShowSerializer < ActiveModel::Serializer
  attributes :name,
             :favorites_count,
             :content,
             :company,
             :phone_number,
             :postal_code,
             :full_address,
             :hotel_facilities,
             :full,
             :average_rating,
             :reviews_count,
             :hotel_images,
             :top_four_reviews,
             :id

  def hotel_images
    return "no image" if object.hotel_images.blank?

    ActiveModelSerializers::SerializableResource.new(
      object.hotel_images,
      each_serializer: HotelImageSerializer,
      adapter: :attributes
    ).serializable_hash
  end

  def full_address
    "#{object.prefecture}#{object.city}#{object.street_address}"
  end

  def top_four_reviews
    return "口コミはまだありません。" if select_top_four_reviews.blank?

    ActiveModelSerializers::SerializableResource.new(
      select_top_four_reviews,
      each_serializer: ReviewIndexSerializer,
      adapter: :attributes
    ).serializable_hash
  end

  def hotel_facilities
    ActiveModelSerializers::SerializableResource.new(
      object.hotel_facility,
      each_serializer: HotelFacilitySerializer,
      adapter: :attributes
    ).serializable_hash
  end

  private

    def select_top_four_reviews
      ReviewOfTopPage.new(reviews_of_a_hotel: object.reviews).extract_top_reviews
    end
end

# frozen_string_literal: true

class HotelShowSerializer < ActiveModel::Serializer
  attributes :name,
             :content,
             :company,
             :phone_number,
             :postal_code,
             :full_address,
             :full,
             :average_rating,
             :reviews_count,
             :hotel_images,
             :day_of_the_week,
             :top_four_reviews

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

  def day_of_the_week
    ActiveModelSerializers::SerializableResource.new(
      select_a_day,
      each_serializer: DaySerializer,
      adapter: :attributes
    ).serializable_hash
  end

  def top_four_reviews
    return "口コミはまだありません。" if select_top_four_reviews.blank?

    ActiveModelSerializers::SerializableResource.new(
      select_top_four_reviews,
      each_serializer: ReviewIndexSerializer,
      adapter: :attributes
    ).serializable_hash
  end

  private

    def select_top_four_reviews
      ReviewOfTopPage.new(reviews_of_a_hotel: object.reviews).extract_top_reviews
    end

    def select_a_day
      if SpecialPeriod.check_that_today_is_a_special_period?(hotel: object)
        Day.special_day.where(hotel_id: object.id).take(1)
      else
        Day.select_a_day_of_the_week.where(hotel_id: object.id)
      end
    end
end

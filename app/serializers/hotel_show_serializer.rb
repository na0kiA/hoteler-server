# frozen_string_literal: true

class HotelShowSerializer < ActiveModel::Serializer

  attributes :id,
             :name,
             :hotel_images,
             :average_rating,
             :reviews_count,
             :day_of_the_week,
             :content,
             :top_four_reviews

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

  def top_four_reviews
    ActiveModelSerializers::SerializableResource.new(
      select_four_reviews,
      each_serializer: ReviewIndexSerializer,
      # reviewer: reviewed_by,
      adapter: :attributes
    ).serializable_hash
  end

  private

  def select_four_reviews
    object.reviews
  end

  def reviewed_by
    select_four_reviews.select(:user_id)
  end

  def select_a_day
    if SpecialPeriod.check_that_today_is_a_special_period?(hotel: object)
      Day.special_day.where(hotel_id: object.id).take(1)
    else
      Day.select_a_day_of_the_week.where(hotel_id: object.id)
    end
  end
end
# frozen_string_literal: true

class ReviewShowSerializer < ActiveModel::Serializer
  attributes :title,
             :content,
             :five_star_rate,
             :helpfulnesses_count,
             :user_id,
             :user_name,
             :user_image,
             :hotel_name,
             :hotel_average_rating,
             :hotel_image,
             :hotel_id,
             :hotel_full_address,
             :hotel_reviews_count,
             :created_date,
             :id

  def created_date
    (I18n.l object.created_at, format: :long)
  end

  def user_name
    object.user.name
  end

  def user_image
    file_url(object.user.image)
  end

  def hotel_name
    object.hotel.name
  end

  def hotel_id
    object.hotel.id
  end

  def hotel_reviews_count
    object.hotel.reviews_count
  end

  def hotel_average_rating
    object.hotel.average_rating
  end

  def hotel_full_address
    "#{object.hotel.prefecture}#{object.hotel.city}#{object.hotel.street_address}"
  end

  def hotel_image
    return  if object.hotel.hotel_images.blank?

    file_url(object.hotel.hotel_images.first)
  end

  private

    def file_url(key)
      Aws::S3::Object.new(ENV.fetch("S3_BUCKET", nil), key).public_url
    end
end

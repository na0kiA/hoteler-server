# frozen_string_literal: true

class ReviewShowSerializer < ActiveModel::Serializer
  attributes :title,
             :content,
             :five_star_rate,
             :helpfulnesses_count,
             :user_name,
             :user_image,
             :hotel_name,
             :hotel_image,
             :created_at

  def user_name
    object.user.name
  end

  def user_image
    file_url(object.user.image)
  end

  def hotel_name
    object.hotel.name
  end

  def hotel_image
    return "no image" if object.hotel.hotel_images.blank?

    file_url(object.hotel.hotel_images.first)
  end

  private

    def file_url(key)
      Aws::S3::Object.new(ENV.fetch("S3_BUCKET", nil), key).public_url
    end
end

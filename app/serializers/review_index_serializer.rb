# frozen_string_literal: true

class ReviewIndexSerializer < ActiveModel::Serializer
  attributes :title,
             :content,
             :five_star_rate,
             :helpfulnesses_count,
             :user_name,
             :user_image,
             :created_date,
             :id,
             :user_id,
             :hotel_name

  def created_date
    (I18n.l object.created_at, format: :long)
  end

  def user_name
    object.user.name
  end

  def hotel_name
    object.hotel.name
  end

  def user_id
    object.user.id
  end

  def user_image
    file_url
  end

  private

    def file_url
      Aws::S3::Object.new(Rails.application.credentials.aws[:s3_bucket], object.user.image).public_url
    end
end

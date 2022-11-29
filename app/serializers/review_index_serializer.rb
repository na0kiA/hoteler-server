# frozen_string_literal: true

class ReviewIndexSerializer < ActiveModel::Serializer
  attributes :title,
             :content,
             :five_star_rate,
             :helpfulnesses_count,
             :user_name,
             :user_image,
             :created_at

  def user_name
    object.user.name
  end

  def user_image
    if object.user.image.blank?
      "blank-profile-picture-g89cfeb4dc_640.png"
    else
      file_url
    end
  end

  private

    def file_url(key:)
      Aws::S3::Object.new(ENV.fetch("S3_BUCKET", nil), key).public_url
    end
end

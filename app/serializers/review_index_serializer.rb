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
    file_url
  end

  private

    def file_url
      Aws::S3::Object.new(ENV.fetch("S3_BUCKET", nil), object.user.image).public_url
    end
end

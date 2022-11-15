# frozen_string_literal: true

class ReviewIndexSerializer < ActiveModel::Serializer
  attributes :title,
             :content,
             :five_star_rate,
             :helpfulnesses,
             :review_images,
             :user_name,
             :created_at

  def helpfulnesses
    object.helpfulnesses.length
  end

  def review_images
    object.review_images.pluck(:key).map do |val|
      file_url(key: val)
    end
  end

  def user_name
    object.user.name
  end

  private

    def file_url(key:)
      Aws::S3::Object.new(ENV.fetch('S3_BUCKET', nil), key).public_url
    end
end
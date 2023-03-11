# frozen_string_literal: true

class HotelImageSerializer < ActiveModel::Serializer
  attributes :id, :file_url, :key

  def file_url
    Aws::S3::Object.new(Rails.application.credentials.aws[:s3_bucket], object.key).public_url
  end
end

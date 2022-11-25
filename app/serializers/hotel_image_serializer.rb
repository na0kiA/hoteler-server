# frozen_string_literal: true

class HotelImageSerializer < ActiveModel::Serializer
  attributes :id, :file_url

  def file_url
    Aws::S3::Object.new(ENV.fetch("S3_BUCKET", nil), object.key).public_url
  end
end

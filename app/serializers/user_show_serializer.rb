# frozen_string_literal: true

class UserShowSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :image,
             :reviews

  delegate :reviews, to: :object

  def image
    if object.image.blank?
      "blank-profile-picture-g89cfeb4dc_640.png"
    else
      converted_file_url
    end
  end

  private

    def converted_file_url
      Aws::S3::Object.new(ENV.fetch("S3_BUCKET", nil), object.image).public_url
    end
end

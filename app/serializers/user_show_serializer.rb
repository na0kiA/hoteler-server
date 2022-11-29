# frozen_string_literal: true

class UserShowSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :image,
             :reviews

  def reviews
    return "口コミはまだありません。" if object.reviews.blank?

    ActiveModelSerializers::SerializableResource.new(
      object.reviews,
      each_serializer: ReviewIndexSerializer,
      user_image: object.image,
      adapter: :attributes
    ).serializable_hash
  end

  def image
    if object.image.blank?
      "blank-profile-picture-g89cfeb4dc_640.png"
    else
      file_url
    end
  end

  private

    def file_url
      Aws::S3::Object.new(ENV.fetch("S3_BUCKET", nil), object.image).public_url
    end

end

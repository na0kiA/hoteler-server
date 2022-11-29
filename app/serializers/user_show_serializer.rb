# frozen_string_literal: true

class UserShowSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :image,
             :reviews

  def reviews
    return "口コミはまだありません。" if object.reviews.blank?

    ActiveModelSerializers::SerializableResource.new(
      object.reviews.eager_load(:hotel, hotel: [:hotel_images]),
      each_serializer: ReviewShowSerializer,
      adapter: :attributes
    ).serializable_hash
  end

  def image
    file_url
  end

  private

    def file_url
      Aws::S3::Object.new(ENV.fetch("S3_BUCKET", nil), object.image).public_url
    end
end

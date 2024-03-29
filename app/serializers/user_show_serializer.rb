# frozen_string_literal: true

class UserShowSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :image,
             :uid,
             :reviews,
             :hotels_count,
             :reviews_count,
             :favorites,
             :hotels

  def reviews
    return "口コミはまだありません。" if object.reviews.blank?

    ActiveModelSerializers::SerializableResource.new(
      object.reviews.eager_load(:hotel, hotel: [:hotel_images]),
      each_serializer: ReviewShowSerializer,
      adapter: :attributes
    ).serializable_hash
  end

  def hotels
    return if object.hotels.blank?

    ActiveModelSerializers::SerializableResource.new(
      object.hotels,
      each_serializer: HotelShowSerializer,
      adapter: :attributes
    ).serializable_hash
  end

  def hotels_count
    return 0 if object.hotels.blank?

    object.hotels.length
  end

  def reviews_count
    return 0 if object.reviews.blank?

    object.reviews.length
  end

  def image
    file_url
  end

  def favorites
    return if object != instance_options[:current_user]

    ActiveModelSerializers::SerializableResource.new(
      object.favorites,
      each_serializer: UserFavoriteSerializer,
      adapter: :attributes
    ).serializable_hash
  end

  private

    def file_url
      Aws::S3::Object.new(Rails.application.credentials.aws[:s3_bucket], object.image).public_url
    end
end

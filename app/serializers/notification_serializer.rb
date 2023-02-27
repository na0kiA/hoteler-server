# frozen_string_literal: true

class NotificationSerializer < ActiveModel::Serializer
  attributes :id,
             :message,
             :kind,
             :read,
             :image,
             :created_date,
             :hotel_id,
             :sender_id,
             :user_id,
             :hotel_name,
             :sender_name,
             :reviewer_rating,
  # def title
  #   return "#{hotel_name}がホテルを更新しました" if object.hotel_updates?
  #   return "#{reviewer_name}があなたのホテルに星#{reviewer_rating}つの口コミを投稿しました" if object.came_reviews?
  # end
             def message
               return object.message if object.hotel_updates?
               return object.message if object.came_reviews?
             end

  def image
    if object.kind == "hotel_updates"
      if object.hotel.hotel_images.first&.key.present?
        Aws::S3::Object.new(ENV.fetch("S3_BUCKET", nil), object.hotel.hotel_images.first&.key).public_url
      end
    else
      Aws::S3::Object.new(ENV.fetch("S3_BUCKET", nil), object.sender.image).public_url
    end
  end

  def created_date
    (I18n.l object.created_at, format: :long)
  end

  def hotel_id
    object.hotel.id
  end

  def hotel_name
    object.hotel.name
  end

  def sender_name
    object.sender.name
  end

  def reviewer_rating
    Review.find_by(user: object.sender)&.five_star_rate
  end
end

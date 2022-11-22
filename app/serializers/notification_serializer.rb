# frozen_string_literal: true

class NotificationSerializer < ActiveModel::Serializer
  attributes :id,
             :title,
             :message,
             :kind,
             :read

  def title
    return "#{hotel_name}さまがホテルを更新しました" if object.hotel_updates?
    return "#{reviewer_name}さんがあなたのホテルに星#{reviewer_rating}つの口コミを投稿しました" if object.came_reviews?
  end

  def message
    return object.message if object.hotel_updates?
    return object.message if object.came_reviews?
  end

  private

    def hotel_name
      object.hotel.name
    end

    def reviewer_name
      object.sender.name
    end

    def reviewer_rating
      Review.find_by(user: object.sender).five_star_rate
    end
end

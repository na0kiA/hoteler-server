# frozen_string_literal: true

class ReviewIndexSerializer < ActiveModel::Serializer
  attributes :user_name,
             :user_image,
             :title,
             :content,
             :five_star_rating,
             :end_time,
             :created_at

  def user_name
    
  end

  private

end

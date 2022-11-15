# frozen_string_literal: true

class ReviewIndexSerializer < ActiveModel::Serializer
  attributes :title,
             :content,
             :five_star_rate,
             :helpfulnesses,
             :created_at

  def helpfulnesses
    object.helpfulnesses.length
  end
end

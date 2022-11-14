# frozen_string_literal: true

class ReviewIndexSerializer < ActiveModel::Serializer
  attributes :title,
             :content,
             :five_star_rate,
             :created_at
end

class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :five_star_rate, :created_at, :updated_at

  belongs_to :user
  belongs_to :hotel
  has_many :helpfulnesses
  has_many :review_images
end

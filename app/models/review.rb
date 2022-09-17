class Review < ApplicationRecord
  belongs_to :user
  belongs_to :hotel
  has_many :review_images, dependent: :destroy
  has_many :helpfulnesses, dependent: :destroy

  # after_commit :update_average_rating, on: [:create, :update]

  # def update_average_rating
  #   Hotel.update!(average_rating: Review.average(:five_star_rate))
  # end
end

# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :user
  belongs_to :hotel
  has_many :review_images, dependent: :destroy
  has_many :helpfulnesses, dependent: :destroy

  after_commit :update_reviews_count_and_rating, on: %i[create update destroy]

  private

    def update_reviews_count_and_rating
      Hotel.update!(hotel_id, reviews_count: count, average_rating: average)
    end

    def count
      Review.where(hotel_id:).count
    end

    def average
      return 0 if Review.where(hotel_id:).blank?

      Review.where(hotel_id:).average(:five_star_rate).round(1)
    end
end

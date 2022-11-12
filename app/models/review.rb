# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :user
  belongs_to :hotel
  has_many :review_images, dependent: :destroy
  has_many :helpfulnesses, dependent: :destroy

  after_commit :update_reviews_count_and_rating, on: %i[create update]

  scope :order_of_most_to_helpful, -> (a_review){ a_review.order() }
  object.reviews.helpfulnesses

  def self.update_zero_rating(set_review:)
    Hotel.update!(set_review.hotel_id, reviews_count: 0, average_rating: 0) if set_review.id == Review.where(hotel_id: set_review.hotel_id).last.id
  end

  def self.order_of_most_to_helpful_top_four(set_hotel:)
    Review.where(hotel_id: set_hotel.id)
    Helpfulness.where(review_id: set_hotel.review_ids)
  end

  private

    def update_reviews_count_and_rating
      Hotel.update!(hotel_id, reviews_count: count, average_rating: average)
    end

    def count
      Review.where(hotel_id:).count
    end

    def average
      Review.where(hotel_id:).average(:five_star_rate).round(1)
    end
end

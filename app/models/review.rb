# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :user
  belongs_to :hotel
  has_many :review_images, dependent: :destroy
  has_many :helpfulnesses, dependent: :destroy
  counter_culture :hotel

  after_commit :update_reviews_count_and_rating, on: %i[create update destroy]

  validates :five_star_rate, inclusion: { in: [1, 2, 3, 4, 5] }, presence: true
  validates :title, length: { minimum: 2, maximum: 30 }, presence: true, invalid_words: true
  validates :content, length: { minimum: 5, maximum: 1000 }, presence: true, invalid_words: true

  private

    def update_reviews_count_and_rating
      return unless Hotel.find_by(id: hotel_id)

      Hotel.update!(hotel_id, average_rating: average)
    end

    def average
      return 0 if Review.where(hotel_id:).blank?

      Review.where(hotel_id:).average(:five_star_rate).round(1)
    end
end

class Review < ApplicationRecord
  belongs_to :user
  belongs_to :hotel
  has_many :review_images, dependent: :destroy
  has_many :helpfulnesses, dependent: :destroy
end

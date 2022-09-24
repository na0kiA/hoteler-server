class Hotel < ApplicationRecord
  scope :accepted, -> { where(accepted: true) }

  belongs_to :user
  has_many :hotel_images, dependent: :destroy
  has_many :hotel_daily_rates, dependent: :destroy
  has_many :reviews, dependent: :destroy
end

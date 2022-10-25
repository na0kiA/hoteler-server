# frozen_string_literal: true

class Hotel < ApplicationRecord
  scope :accepted, -> { where(accepted: true) }

  belongs_to :user
  has_many :hotel_images, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :days, dependent: :destroy
  has_many :rest_rates, through: :days
end

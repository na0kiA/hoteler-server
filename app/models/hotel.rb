class Hotel < ApplicationRecord
  scope :accepted, -> { where(accepted: true) }

  belongs_to :user
  has_many :hotel_images, dependent: :destroy
  has_many :reviews, dependent: :destroy

  # class << self
  #   def create!(params)
  #     ActiveRecord::Base.transaction do
  #       hotel = Hotel.new(name: params[:name], content: params[:content], user_id: params[:user_id])
  #       hotel.save!
  #       hotel_images = HotelImage.new(hotel_id: hotel.id, key: params[:hotel_images][0][:key], file_url: params[:hotel_images][0][:file_url])
  #       hotel_images.save!
  #     end
  #   end
  # end
end

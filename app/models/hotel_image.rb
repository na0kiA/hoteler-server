class HotelImage < ApplicationRecord
  belongs_to :hotel
  # attr_reader :key, :file_url, :hotel_id

  # def initialize(key:, file_url: file_url.convert, hotel_id:)
  #   super()
  #   @key = key
  #   @file_url = file_url.convert
  #   @hotel_id = hotel_id
  # end
  # class << self
  #   def create_hotel_images!(params)
  #       hotel_images = HotelImage.new(hotel_id: search_last_hotel, key: params[:hotel_images][0][:key], file_url: params[:hotel_images][0][:file_url])
  #       hotel_images.save!
  #   end
  # end

  # private
  #   def search_last_hotel
  #     Hotel.find.last.id
  #   end
end

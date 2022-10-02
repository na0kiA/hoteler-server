# frozen_string_literal: true

class HotelSerializer < ActiveModel::Serializer
  # include HotelIncludable

  # attributes :hotel
  attributes :id, :name, :content, :average_rating, :reviews_count, :days
  

  has_many :days,  serializer: DaySerializer

  def hotel
    Hotel.includes(:hotel_images, days: :rest_rates)
  end
end
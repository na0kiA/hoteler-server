# frozen_string_literal: true

class HotelImage < ApplicationRecord
  belongs_to :hotel

  validates :key, presence: true

  def save!
    find_or_create_key
    # remove_unnecessary_key
  end

  private

  def find_or_create_key
    JSON.parse(key).each do |val|
      HotelImage.find_or_create_by!(key: val)
    end
  end
  
  # def remove_unnecessary_key
  #   p HotelImage.pluck(:key)
  #   p find_or_create_key.difference(key)
  #   HotelImage.where(key: HotelImage.pluck(:key).difference(key)).delete_all
  # end
end

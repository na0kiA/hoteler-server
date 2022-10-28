# frozen_string_literal: true

class HotelImage < ApplicationRecord
  belongs_to :hotel

  validates :key, presence: true

  def save
    remove_unnecessary_key
    create_hotel_images
  end

  # def update(set_hotel_images:, image_params:)
  #   remove_unnecessary_key

  # end

  private

    def create_hotel_images
      JSON.parse(key).map do |val|
        break if val.blank?

        HotelImage.find_or_create_by!(key: val, hotel_id:)
      end
    end

    def remove_unnecessary_key
      HotelImage.where(key: difference_key_array).delete_all
    end

    def difference_key_array
      HotelImage.where(hotel_id:).pluck(:key).difference(JSON.parse(key))
    end
end

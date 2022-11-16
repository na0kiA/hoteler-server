# frozen_string_literal: true

class HotelImage < ApplicationRecord
  belongs_to :hotel

  validates :key, presence: true

  def save
    return if too_many_value? || key.blank?

    # keyはフロントから配列で送られてくるので、重複したkeyを削除する必要がある
    ActiveRecord::Base.transaction do
      remove_unnecessary_key
      create_hotel_images
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  # def too_many_value?
  #   HotelImage.where(hotel_id:).length > 10
  # end

  def too_many_value?
    return if key.blank?

    JSON.parse(key).length > 10
  end

  private

    def create_hotel_images
      JSON.parse(key).map do |val|
        # break if val.blank?
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

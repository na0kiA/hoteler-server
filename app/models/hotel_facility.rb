# frozen_string_literal: true

class HotelFacility < ApplicationRecord
  self.primary_key = "hotel_id"

  belongs_to :hotel
end

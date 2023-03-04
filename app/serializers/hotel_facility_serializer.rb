# frozen_string_literal: true

class HotelFacilitySerializer < ActiveModel::Serializer
  attribute :wifi_enabled
  attribute :parking_enabled
  attribute :credit_card_enabled
  attribute :phone_reservation_enabled
  attribute :net_reservation_enabled
  attribute :triple_rooms_enabled
  attribute :secret_payment_enabled
  attribute :cooking_enabled
  attribute :breakfast_enabled
  attribute :coupon_enabled
end

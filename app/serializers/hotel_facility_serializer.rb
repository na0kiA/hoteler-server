# frozen_string_literal: true

class HotelFacilitySerializer < ActiveModel::Serializer
  attribute :wifi_enabled do
    "Wi-Fiあり" if object.wifi_enabled
  end
  attribute :parking_enabled do
    "駐車場あり" if object.parking_enabled
  end
  attribute :credit_card_enabled do
    "クレジットカード利用可能" if object.credit_card_enabled
  end
  attribute :phone_reservation_enabled do
    "電話予約可能" if object.phone_reservation_enabled
  end
  attribute :net_reservation_enabled do
    "ネット予約可能" if object.net_reservation_enabled
  end
  attribute :triple_rooms_enabled do
    "3人以上利用可能" if object.triple_rooms_enabled
  end
  attribute :secret_payment_enabled do
    "会計時にフロントと会わない" if object.secret_payment_enabled
  end
  attribute :cooking_enabled do
    "料理あり" if object.cooking_enabled
  end
  attribute :breakfast_enabled do
    "朝食あり" if object.breakfast_enabled
  end
  attribute :coupon_enabled do
    "クーポンあり" if object.coupon_enabled
  end
end

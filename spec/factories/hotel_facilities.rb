# frozen_string_literal: true

FactoryBot.define do
  factory :hotel_facility do
    trait :with_random_facility do
      wifi_enabled { [true, false].sample }
      parking_enabled { [true, false].sample }
      credit_card_enabled { [true, false].sample }
      phone_reservation_enabled { [true, false].sample }
      net_reservation_enabled { [true, false].sample }
      triple_rooms_enabled { [true, false].sample }
      secret_payment_enabled { [true, false].sample }
      cooking_enabled { [true, false].sample }
      breakfast_enabled { [true, false].sample }
      coupon_enabled { [true, false].sample }
    end
  end
end

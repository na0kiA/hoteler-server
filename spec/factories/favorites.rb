# frozen_string_literal: true

FactoryBot.define do
  factory :favorite do

    trait :with_hotel_and_image do
      association :hotel, factory: :with_user_and_hotel_images
    end

    trait :with_hotel do
      association :hotel, factory: :with_user_completed_hotel
    end

    trait :with_user do
      association :user
    end

    factory :with_user_favorite, traits: %i[with_user]
    factory :with_hotel_favorite, traits: %i[with_hotel]
    factory :with_hotel_and_image_favorite, traits: %i[with_hotel_and_image]
    factory :with_completed_favorite, traits: %i[with_hotel_and_image_favorite with_user]
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :favorite do

    trait :with_user do
      user_id { FactoryBot.create(:user).id }
    end

    trait :with_hotel do
      hotel_id { FactoryBot.create(:completed_profile_hotel, :with_hotel_images, :with_user).id }
    end

    # factory :with_user_favorite, traits: %i[with_user]
    # factory :with_hotel_favorite, traits: %i[with_hotel]
  end
end
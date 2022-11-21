# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@gmail.com" }
    sequence(:password) { |n| "test#{n}111" }
    sequence(:password_confirmation) { |n| "test#{n}111" }

    trait :with_hotel_user do
      after(:build) do |user|
        user.hotels << FactoryBot.build(:completed_profile_hotel, :with_hotel_images)
      end
    end

    trait :with_send_notifications_user do
      after(:build) do |user|
        user.notifications << FactoryBot.build(:notification, :with_hotel_updates)
      end
    end
  end
end

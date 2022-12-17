# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "太郎#{n}" }
    sequence(:email) { |n| "#{n}test#{n}@example.com" }
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

  factory :other_user, class: "User" do
    sequence(:email) { |n| "#{n}tests#{n}@example.com" }
    sequence(:password) { |n| "test#{n}111" }
    sequence(:password_confirmation) { |n| "test#{n}111" }
  end

  factory :other_user2, class: "User" do
    sequence(:email) { |n| "#{n}tester#{n}@example.com" }
    sequence(:password) { |n| "test#{n}111" }
    sequence(:password_confirmation) { |n| "test#{n}111" }
  end

  factory :other_user3, class: "User" do
    sequence(:email) { |n| "#{n}testers#{n}@example.com" }
    sequence(:password) { |n| "test#{n}111" }
    sequence(:password_confirmation) { |n| "test#{n}111" }
  end
end

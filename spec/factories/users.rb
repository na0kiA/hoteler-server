# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "太郎#{n}" }
    sequence(:email) { |n| "tester#{n}@example.com" }
    sequence(:password) { |n| "test#{n}#{n}#{n}#{n}111" }
    sequence(:password_confirmation) { |n| "test#{n}#{n}#{n}#{n}111" }

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

  factory :sample_user, class: "User" do
    sequence(:name) { "かずき" }
    sequence(:email) { |n| "testers#{n}@example.com" }
    sequence(:password) { |n| "test#{n}#{n}#{n}#{n}111" }
    sequence(:password_confirmation) { |n| "test#{n}#{n}#{n}#{n}111" }
    sequence(:image) { "uploads/hoteler/4786f605-a290-4849-929f-cafbacb46beb/user-top-#{(0..119).to_a.sample}.jpg" }
  end
end

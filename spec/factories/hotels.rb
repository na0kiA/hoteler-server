# frozen_string_literal: true

FactoryBot.define do
  factory :hotel do
    accepted { false }
    sequence(:name) { |n| "hotel#{n}" }
    sequence(:content) { |n| "hotel_content#{n}" }
  end

  factory :accepted_hotel, class: "Hotel" do
    accepted { true }
    sequence(:name) { |n| "hotel#{n}" }
    sequence(:content) { |n| "hotel_content#{n}" }

    trait :with_user do
      association :user
    end
  end

  factory :completed_profile_hotel, class: "Hotel" do
    accepted { true }
    sequence(:name) { |n| "hotel#{n}" }
    sequence(:content) { |n| "hotel_content#{n}" }
    sequence(:company) { |n| "株式会社ホテルサービス#{n}" }
    sequence(:phone_number) { |n| "000-1234-123#{n}" }
    sequence(:prefecture) { |n| "東京#{n}" }
    sequence(:city) { |n| "渋谷#{n}" }
    sequence(:postal_code) { |n| "000-000#{n}" }
    sequence(:street_adress) { |n| "2丁目174-#{n}" }
    sequence(:content) { |n| "hotel_content#{n}" }
    reviews_count { 0 }
    average_rating { 0.0 }

    trait :with_hotel_images do
      after(:build) do |hotel|
        hotel.hotel_images << FactoryBot.build(:hotel_image, :with_completed_profile_hotel)
      end
    end

    trait :with_user do
      association :user
    end

    trait :with_days_and_service_rates do
      after(:build) do |hotel|
        hotel.days << FactoryBot.build(:day, :monday_through_thursday, :with_rest_rates, :with_stay_rates)
        hotel.days << FactoryBot.build(:day, :friday, :with_rest_rates, :with_day_off_stay_rates)
        hotel.days << FactoryBot.build(:day, :saturday, :with_day_off_rest_rates, :with_day_off_stay_rates)
        hotel.days << FactoryBot.build(:day, :sunday, :with_day_off_rest_rates, :with_stay_rates)
        hotel.days << FactoryBot.build(:day, :holiday, :with_day_off_rest_rates, :with_stay_rates)
        hotel.days << FactoryBot.build(:day, :day_before_a_holiday, :with_day_off_rest_rates, :with_day_off_stay_rates)
        hotel.days << FactoryBot.build(:day, :special_days, :with_special_rest_rates, :with_special_stay_rates, :with_special_period)
      end
    end

    trait :with_reviews_and_helpfulnesses do
      after(:build) do |hotel|
        hotel.reviews << FactoryBot.build(:review, :five_star_rated_review)
        hotel.reviews << FactoryBot.build(:review, :four_star_rated_review)
        hotel.reviews << FactoryBot.build(:review, :three_star_rated_review)
        hotel.reviews << FactoryBot.build(:review, :two_star_rated_review)
        hotel.reviews << FactoryBot.build(:review, :one_star_rated_review)
      end
    end

    trait :with_reviews do
      after(:build) do |hotel|
        hotel.reviews << FactoryBot.build(:review, :five_star_rated_review)
        hotel.reviews << FactoryBot.build(:review, :four_star_rated_review)
        hotel.reviews << FactoryBot.build(:review, :three_star_rated_review)
        hotel.reviews << FactoryBot.build(:review, :two_star_rated_review)
        hotel.reviews << FactoryBot.build(:review, :one_star_rated_review)
      end
    end

    trait :with_days do
      after(:build) do |hotel|
        hotel.days << FactoryBot.build(:day, :monday_through_thursday)
        hotel.days << FactoryBot.build(:day, :friday)
        hotel.days << FactoryBot.build(:day, :saturday)
        hotel.days << FactoryBot.build(:day, :sunday)
        hotel.days << FactoryBot.build(:day, :holiday)
        hotel.days << FactoryBot.build(:day, :day_before_a_holiday)
        hotel.days << FactoryBot.build(:day, :special_days, :with_special_period)
      end
    end

    factory :with_five_reviews_and_helpfulnesses, traits: %i[with_days_and_service_rates with_reviews_and_helpfulnesses]
    factory :with_user_and_hotel_images, traits: %i[with_user with_hotel_images]
    factory :with_user_completed_hotel, traits: %i[with_user]
  end
end

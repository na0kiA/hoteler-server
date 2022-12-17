# frozen_string_literal: true

FactoryBot.define do
  factory :hotel do
    accepted { false }
    sequence(:name) { |n| "ホテルラダー#{n}" }
    sequence(:content) { |n| "最高峰のラグジュアリホテルをお届けします#{n}" }
    sequence(:company) { |n| "株式会社ホテルサービス#{n}" }
    sequence(:phone_number) { |n| "0001234123#{n}" }
    sequence(:prefecture) { |n| "東京#{n}" }
    sequence(:city) { |n| "渋谷#{n}" }
    sequence(:postal_code) { |n| "000000#{n}" }
    sequence(:street_address) { |n| "2丁目174-#{n}" }
  end

  factory :accepted_hotel, class: "Hotel" do
    accepted { true }
    sequence(:name) { |n| "hotel#{n}" }
    sequence(:content) { |n| "hotel_content#{n}" }
    sequence(:company) { |n| "株式会社ホテルサービス#{n}" }
    sequence(:phone_number) { |n| "0001234123#{n}" }
    sequence(:prefecture) { |n| "東京#{n}" }
    sequence(:city) { |n| "渋谷#{n}" }
    sequence(:postal_code) { |n| "000000#{n}" }
    sequence(:street_address) { |n| "2丁目174-#{n}" }

    trait :with_user do
      association :user
    end
  end

  factory :completed_profile_hotel, class: "Hotel" do
    accepted { true }
    sequence(:name) { |n| "hotel#{n}" }
    sequence(:content) { |n| "hotel_content#{n}" }
    sequence(:company) { |n| "株式会社ホテルサービス#{n}" }
    sequence(:phone_number) { |n| "0001234123#{n}" }
    sequence(:prefecture) { |n| "東京#{n}" }
    sequence(:city) { |n| "渋谷#{n}" }
    sequence(:postal_code) { |n| "000000#{n}" }
    sequence(:street_address) { |n| "2丁目174-#{n}" }
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

    trait :with_rest_rates do
      after(:create) do |hotel|
        hotel.days[0].rest_rates << FactoryBot.build(:rest_rate, :normal_rest_rate, :short_rest_rate, :morning_rest_rate, :midnight_rest_rate)
        hotel.days[1].rest_rates << FactoryBot.build(:rest_rate, :normal_rest_rate, :midnight_rest_rate)
        hotel.days[2].rest_rates << FactoryBot.build(:day_off_rest_rate, :normal_rest_rate, :midnight_rest_rate)
        hotel.days[3].rest_rates << FactoryBot.build(:day_off_rest_rate, :normal_rest_rate, :midnight_rest_rate)
        hotel.days[4].rest_rates << FactoryBot.build(:day_off_rest_rate, :normal_rest_rate, :midnight_rest_rate)
        hotel.days[5].rest_rates << FactoryBot.build(:day_off_rest_rate, :normal_rest_rate, :midnight_rest_rate)
        hotel.days[6].rest_rates << FactoryBot.build(:special_rest_rate, :normal_rest_rate, :midnight_rest_rate)
      end
    end

    trait :with_stay_rates do
      after(:create) do |hotel|
        hotel.days[0].stay_rates << FactoryBot.build(:stay_rate, :long_stay_rate, :midnight_stay_rate)
        hotel.days[1].stay_rates << FactoryBot.build(:stay_rate, :long_stay_rate, :midnight_stay_rate)
        hotel.days[2].stay_rates << FactoryBot.build(:day_off_stay_rate, :normal_stay_rate, :midnight_stay_rate)
        hotel.days[3].stay_rates << FactoryBot.build(:day_off_stay_rate, :normal_stay_rate, :midnight_stay_rate)
        hotel.days[4].stay_rates << FactoryBot.build(:day_off_stay_rate, :normal_stay_rate, :midnight_stay_rate)
        hotel.days[5].stay_rates << FactoryBot.build(:day_off_stay_rate, :normal_stay_rate, :midnight_stay_rate)
        hotel.days[6].stay_rates << FactoryBot.build(:special_stay_rate, :normal_stay_rate, :midnight_stay_rate)
      end
    end

    trait :with_special_periods do
      after(:create) do |hotel|
        hotel.days[6].special_periods << FactoryBot.build(:normal_special_periods)
      end
    end

    trait :with_days_and_expensive_service_rates do
      after(:build) do |hotel|
        hotel.days << FactoryBot.build(:day, :monday_through_thursday, :with_expensive_rest_rates, :with_expensive_stay_rates)
        hotel.days << FactoryBot.build(:day, :friday, :with_expensive_rest_rates, :with_expensive_day_off_stay_rates)
        hotel.days << FactoryBot.build(:day, :saturday, :with_expensive_day_off_rest_rates, :with_expensive_day_off_stay_rates)
        hotel.days << FactoryBot.build(:day, :sunday, :with_expensive_day_off_rest_rates, :with_expensive_stay_rates)
        hotel.days << FactoryBot.build(:day, :holiday, :with_expensive_day_off_rest_rates, :with_expensive_stay_rates)
        hotel.days << FactoryBot.build(:day, :day_before_a_holiday, :with_expensive_day_off_rest_rates, :with_expensive_day_off_stay_rates)
        hotel.days << FactoryBot.build(:day, :special_days, :with_expensive_special_rest_rates, :with_expensive_special_stay_rates, :with_special_period)
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
    factory :with_service_completed_hotel, traits: %i[with_rest_rates with_stay_rates with_special_periods]
  end
end

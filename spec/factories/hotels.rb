# frozen_string_literal: true

FactoryBot.define do
  factory :hotel do
    accepted { false }
    sequence(:name) { |n| "hotel#{n}" }
    sequence(:content) { |n| "hotel_content#{n}" }
  end

  factory :accepted_hotel, class: 'Hotel' do
    accepted { true }
    sequence(:name) { |n| "hotel#{n}" }
    sequence(:content) { |n| "hotel_content#{n}" }
  end

  factory :completed_profile_hotel, class: 'Hotel' do
    accepted { true }
    sequence(:name) { |n| "hotel#{n}" }
    sequence(:content) { |n| "hotel_content#{n}" }

    trait :with_hotel_images do
      after(:build) do |hotel|
        hotel.hotel_images << FactoryBot.build(:hotel_image)
      end
    end

    trait :with_a_day_and_service_rates do
      after(:build) do |hotel|
        hotel.days << FactoryBot.build(:day, :monday_through_thursday, :with_rest_rates, :with_stay_rates)
        hotel.days << FactoryBot.build(:day, :friday, :with_rest_rates, :with_day_off_stay_rates)
        hotel.days << FactoryBot.build(:day, :saturday, :with_day_off_rest_rates, :with_day_off_stay_rates)
        hotel.days << FactoryBot.build(:day, :sunday, :with_day_off_rest_rates, :with_stay_rates)
        hotel.days << FactoryBot.build(:day, :holiday, :with_day_off_rest_rates, :with_stay_rates)
        hotel.days << FactoryBot.build(:day, :day_before_a_holiday, :with_rest_rates, :with_day_off_stay_rates)
        hotel.days << FactoryBot.build(:day, :special_days, :with_special_rest_rates, :with_special_stay_rates, :with_special_period)
      end
    end

    # trait :with_a_special_day_and_rest_rates do
    #   after(:build) do |hotel|
    #     hotel.days << FactoryBot.build(:day, :special_days, :with_special_period_rest_rates)
    #   end
    # end

    trait :with_days do
      after(:build) do |hotel|
        hotel.days << FactoryBot.build(:day, :monday_through_thursday)
        hotel.days << FactoryBot.build(:day, :friday)
        hotel.days << FactoryBot.build(:day, :saturday)
        hotel.days << FactoryBot.build(:day, :sunday)
        hotel.days << FactoryBot.build(:day, :holiday)
        hotel.days << FactoryBot.build(:day, :day_before_a_holiday)
        hotel.days << FactoryBot.build(:day, :special_days)
      end
    end
  end
end

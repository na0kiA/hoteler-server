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

    association :user

    trait :with_a_day_and_rest_rates do
      after(:build) do |hotel|
        hotel.days << FactoryBot.build(:day, :monday_through_thursday, :with_rest_rates)
        hotel.days << FactoryBot.build(:day, :friday, :with_rest_rates)
        hotel.days << FactoryBot.build(:day, :saturday, :with_rest_rates)
        hotel.days << FactoryBot.build(:day, :sunday, :with_rest_rates)
        hotel.days << FactoryBot.build(:day, :holiday, :with_rest_rates)
        hotel.days << FactoryBot.build(:day, :day_before_a_holiday, :with_rest_rates)
        hotel.days << FactoryBot.build(:day, :special_days, :with_rest_rates)
      end
    end
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :special_period do
    trait :golden_week do
      period { "golden_week" }
      start_date { "2023-5-2" }
      end_date { "2023-5-10" }
    end

    trait :obon do
      period { "obon" }
      start_date { "2023-8-8" }
      end_date { "2023-8-15" }
    end

    trait :the_new_years_holiday do
      period { "the_new_years_holiday" }
      start_date { "2023-12-15" }
      end_date { "2024-1-5" }
    end

    factory :normal_special_periods, traits: %i[golden_week obon the_new_years_holiday]
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :day do
    trait :with_rest_rates do
      after(:build) do |day|
        day.rest_rates << FactoryBot.build(:rest_rate, :normal_rest_rate)
        day.rest_rates << FactoryBot.build(:rest_rate, :short_rest_rate)
        day.rest_rates << FactoryBot.build(:rest_rate, :midnight_rest_rate)
      end
    end

    trait :with_special_period_and_rest_rates do
      after(:build) do |day|
        day.rest_rates << FactoryBot.build(:rest_rate, :normal_rest_rate)
        day.rest_rates << FactoryBot.build(:rest_rate, :short_rest_rate)
        day.rest_rates << FactoryBot.build(:rest_rate, :midnight_rest_rate)
        day.special_periods << FactoryBot.build(:special_period, :golden_week)
        day.special_periods << FactoryBot.build(:special_period, :obon)
        day.special_periods << FactoryBot.build(:special_period, :the_new_years_holiday)
      end
    end

    trait :monday_through_thursday do
      day { '月曜から木曜' }
    end

    trait :friday do
      day { '金曜' }
    end

    trait :saturday do
      day { '土曜' }
    end

    trait :sunday do
      day { '日曜' }
    end

    trait :holiday do
      day { '祝日' }
    end

    trait :day_before_a_holiday do
      day { '祝前日' }
    end

    trait :special_days do
      day { '特別期間' }
    end
  end
end

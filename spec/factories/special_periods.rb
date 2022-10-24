# frozen_string_literal: true

FactoryBot.define do
  factory :special_period do
    periods { 'golden_week' }
    start_date { '2023-5-2' }
    end_date { '2023-5-10' }
  end

  factory :golden_week, class: 'SpecialPeriod' do
    periods { 'golden_week' }
    start_date { '2023-5-2' }
    end_date { '2023-5-10' }
    association :day, factory: :special_days
  end
  factory :obon, class: 'SpecialPeriod' do
    periods { 'obon' }
    start_date { '2023-8-8' }
    end_date { '2023-8-15' }
    association :day, factory: :special_days
  end
  factory :the_new_years_holiday, class: 'SpecialPeriod' do
    periods { 'the_new_years_holiday' }
    start_date { '2023-12-15' }
    end_date { '2024-1-5' }
    association :day, factory: :special_days
  end
end

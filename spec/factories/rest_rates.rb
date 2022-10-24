# frozen_string_literal: true

FactoryBot.define do
  factory :rest_rate do
    plan { '休憩90分' }
    rate { 3980 }
    first_time { '6:00' }
    last_time { '24:00' }
    association :day, factory: :weekdays
    association :day, factory: :friday
    association :day, factory: :saturday
    association :day, factory: :sunday
    association :day, factory: :holiday
    association :day, factory: :day_before_a_holiday
  end
  factory :normal_rest_rate, class: 'RestRate' do
    plan { '休憩90分' }
    rate { 3980 }
    first_time { '6:00' }
    last_time { '24:00' }
    association :day, factory: :weekdays
    association :day, factory: :friday
    association :day, factory: :saturday
    association :day, factory: :sunday
    association :day, factory: :holiday
    association :day, factory: :day_before_a_holiday
  end
  
  factory :midnight_rest_rate, class: 'RestRate' do
    plan { '深夜休憩90分' }
    rate { 4980 }
    first_time { '0:00' }
    last_time { '5:00' }
    association :day, factory: :weekdays
    association :day, factory: :friday
    association :day, factory: :saturday
    association :day, factory: :sunday
    association :day, factory: :holiday
    association :day, factory: :day_before_a_holiday
  end
end

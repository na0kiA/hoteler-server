# frozen_string_literal: true

FactoryBot.define do
  factory :rest_rate do
    trait :normal_rest_rate do
      plan { '休憩90分' }
      rate { 3980 }
      first_time { '6:00' }
      last_time { '24:00' }
    end

    trait :short_rest_rate do
      plan { '休憩60分' }
      rate { 3280 }
      first_time { '6:00' }
      last_time { '24:00' }
    end

    trait :midnight_rest_rate do
      plan { '深夜休憩90分' }
      rate { 4980 }
      first_time { '0:00' }
      last_time { '5:00' }
    end
  end
end

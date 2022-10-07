# frozen_string_literal: true

FactoryBot.define do
  factory :rest_rate do
    plan { '休憩90分' }
    rate { 3980 }
    first_time { '6:00' }
    last_time { '24:00' }
  end
  factory :midnight_rate, class: 'RestRate' do
    plan { '深夜休憩90分' }
    rate { 4980 }
    first_time { '0:00' }
    last_time { '5:00' }
  end
end

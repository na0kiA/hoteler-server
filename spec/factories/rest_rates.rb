FactoryBot.define do
  factory :rest_rate do
    sequence(:plan) { "休憩90分" }
    sequence(:rate) { 3980 }
    sequence(:first_time) { "6:00" }
    sequence(:last_time) { "24:00" }
  end
end

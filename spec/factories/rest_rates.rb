# frozen_string_literal: true

FactoryBot.define do
  factory :rest_rate do
    trait :normal_rest_rate do
      plan { "休憩90分" }
      rate { 3980 }
      start_time { "6:00" }
      end_time { "24:00" }
    end

    trait :short_rest_rate do
      plan { "休憩60分" }
      rate { 3280 }
      start_time { "6:00" }
      end_time { "24:00" }
    end

    trait :morning_rest_rate do
      plan { "早朝休憩90分" }
      rate { 4980 }
      start_time { "4:00" }
      end_time { "11:00" }
    end

    trait :midnight_rest_rate do
      plan { "深夜休憩90分" }
      rate { 4980 }
      start_time { "0:00" }
      end_time { "5:00" }
    end
    
    factory :day_off_rest_rate, class: "RestRate" do
      trait :normal_rest_rate do
        plan { "休憩90分" }
        rate { 5980 }
        start_time { "6:00" }
        end_time { "24:00" }
      end

      trait :midnight_rest_rate do
        plan { "深夜休憩90分" }
        rate { 6980 }
        start_time { "0:00" }
        end_time { "5:00" }
      end
    end

    factory :special_rest_rate, class: "RestRate" do
      trait :midnight_rest_rate do
        plan { "深夜休憩90分" }
        rate { 6980 }
        start_time { "0:00" }
        end_time { "5:00" }
      end

      trait :normal_rest_rate do
        plan { "休憩90分" }
        rate { 5980 }
        start_time { "6:00" }
        end_time { "23:00" }
      end
    end
  end

  factory :expensive_rest_rate, class: "RestRate" do
    trait :normal_rest_rate do
      plan { "休憩90分" }
      rate { 4980 }
      start_time { "6:00" }
      end_time { "24:00" }
    end

    trait :short_rest_rate do
      plan { "休憩60分" }
      rate { 4280 }
      start_time { "6:00" }
      end_time { "24:00" }
    end

    trait :morning_rest_rate do
      plan { "早朝休憩90分" }
      rate { 5980 }
      start_time { "4:00" }
      end_time { "11:00" }
    end

    trait :midnight_rest_rate do
      plan { "深夜休憩90分" }
      rate { 6980 }
      start_time { "0:00" }
      end_time { "5:00" }
    end

    factory :expensive_day_off_rest_rate, class: "RestRate" do
      trait :normal_rest_rate do
        plan { "休憩90分" }
        rate { 6980 }
        start_time { "6:00" }
        end_time { "24:00" }
      end

      trait :midnight_rest_rate do
        plan { "深夜休憩90分" }
        rate { 7980 }
        start_time { "0:00" }
        end_time { "5:00" }
      end
    end

    factory :expensive_special_rest_rate, class: "RestRate" do
      trait :midnight_rest_rate do
        plan { "深夜休憩90分" }
        rate { 7980 }
        start_time { "0:00" }
        end_time { "5:00" }
      end

      trait :normal_rest_rate do
        plan { "休憩90分" }
        rate { 6980 }
        start_time { "6:00" }
        end_time { "23:00" }
      end
    end
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :random_rest_rate, class: "RestRate" do
    trait :normal_rest_rate do
      plan { %w[休憩90分 休憩100分 休憩80分 ノーマルレスト].sample.to_s }
      rate { Random.new.rand(4000..6000).ceil(-1) }
      start_time { "#{(6..15).to_a.sample}:00" }
      end_time { "24:00" }
    end

    trait :long_rest_rate do
      plan { %w[休憩120分 休憩180分 ロングタイム180分].sample.to_s }
      rate { Random.new.rand(6000..9000).ceil(-1) }
      start_time { "#{(6..15).to_a.sample}:00" }
      end_time { "22:00" }
    end

    trait :short_rest_rate do
      plan { ["休憩60分", "ショート休憩60分, ショートタイム60分"].sample.to_s }
      rate { Random.new.rand(3000..5000).ceil(-1) }
      start_time { "#{(6..14).to_a.sample}:00" }
      end_time { "24:00" }
    end

    trait :morning_rest_rate do
      plan { "早朝休憩#{[60, 90].sample}分" }
      rate { Random.new.rand(3000..5000).ceil(-1) }
      start_time { "#{(4..6).to_a.sample}:00" }
      end_time { "#{(9..12).to_a.sample}1:00" }
    end

    trait :midnight_rest_rate do
      plan { ["夜中休憩60分", "深夜休憩90分, ミッドナイト休憩90分"].sample.to_s }
      rate { Random.new.rand(4000..5000).ceil(-1) }
      start_time { "#{(0..3).to_a.sample}:00" }
      end_time { "#{(4..6).to_a.sample}:00" }
    end
  end

  factory :random_day_off_rest_rate, class: "RestRate" do
    trait :normal_rest_rate do
      plan { "休憩90分" }
      rate { Random.new.rand(4000..6000).ceil(-1) }
      start_time { "#{(6..15).to_a.sample}:00" }
      end_time { "24:00" }
    end

    trait :long_rest_rate do
      plan { "休憩#{[120, 180, 200].sample}分" }
      rate { Random.new.rand(6000..9000).ceil(-1) }
      start_time { "#{(6..15).to_a.sample}:00" }
      end_time { "22:00" }
    end

    trait :midnight_rest_rate do
      plan { "深夜休憩#{[60, 90].sample}分" }
      rate { Random.new.rand(5000..8000).ceil(-1) }
      start_time { "#{(0..3).to_a.sample}:00" }
      end_time { "#{(4..6).to_a.sample}:00" }
    end
  end

  factory :random_special_rest_rate, class: "RestRate" do
    trait :midnight_rest_rate do
      plan { "深夜休憩90分" }
      rate { Random.new.rand(8000..10_000).ceil(-1) }
      start_time { "0:00" }
      end_time { "5:00" }
    end

    trait :normal_rest_rate do
      plan { "休憩90分" }
      rate { Random.new.rand(6000..9000).ceil(-1) }
      start_time { "6:00" }
      end_time { "23:00" }
    end
  end
end

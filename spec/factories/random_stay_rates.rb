# frozen_string_literal: true

FactoryBot.define do
  factory :random_stay_rate, class: "StayRate" do
    trait :normal_stay_rate do
      plan { %w[宿泊1部 アーリーステイ ウィークデイステイ].sample.to_s }
      rate { Random.new.rand(5000..7000).ceil(-1) }
      start_time { "#{(19..21).to_a.sample}:00" }
      end_time { "11:00" }
    end

    trait :long_stay_rate do
      plan { %w[宿泊2部 ロングステイ レイトステイ].sample.to_s }
      rate { Random.new.rand(6000..9000).ceil(-1) }
      start_time { "#{(22..24).to_a.sample}:00" }
      end_time { "15:00" }
    end

    trait :midnight_stay_rate do
      plan { %w[素泊まり 深夜宿泊 ショートステイ ミッドナイトステイ].sample.to_s }
      rate { Random.new.rand(4000..6000).ceil(-1) }
      start_time { "#{(0..3).to_a.sample}:00" }
      end_time { "9:00" }
    end
  end

  factory :random_day_off_stay_rate, class: "StayRate" do
    trait :normal_stay_rate do
      plan { %w[宿泊1部 宿泊2部 デイオフステイ ウィークエンドステイ].sample.to_s }
      rate { Random.new.rand(10_000..14_000).ceil(-1) }
      start_time { "#{(21..24).to_a.sample}:00" }
      end_time { "11:00" }
    end

    trait :midnight_stay_rate do
      plan { %w[素泊まり 深夜宿泊 ショートステイ ミッドナイトステイ].sample.to_s }
      rate { Random.new.rand(7000..9000).ceil(-1) }
      start_time { "#{(0..3).to_a.sample}:00" }
      end_time { "9:00" }
    end
  end

  factory :raundom_special_stay_rate, class: "StayRate" do
    trait :midnight_stay_rate do
      plan { %w[素泊まり 深夜宿泊 ショートステイ].sample.to_s }
      rate { Random.new.rand(10_000..14_000).ceil(-1) }
      start_time { "#{(0..3).to_a.sample}:00" }
      end_time { "9:00" }
    end

    trait :normal_stay_rate do
      plan { "宿泊1部" }
      rate { Random.new.rand(10_000..14_000).ceil(-1) }
      start_time { "#{(19..24).to_a.sample}:00" }
      end_time { "11:00" }
    end
  end
end

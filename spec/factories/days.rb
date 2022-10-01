# frozen_string_literal: true

FactoryBot.define do
  factory :day do
    sequence(:day) { '月曜から木曜' }
  end
end

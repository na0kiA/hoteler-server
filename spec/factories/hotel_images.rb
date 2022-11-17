# frozen_string_literal: true

FactoryBot.define do
  factory :hotel_image do
    sequence(:key) { |n| "aws/s3/keys1998/#{n}" }
  end
end

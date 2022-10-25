# frozen_string_literal: true

FactoryBot.define do
  factory :hotel_image do
    sequence(:key) { |n| "aws/s3/keys/199#{n}" }
    association :hotel, factory: :completed_profile_hotel
  end
end

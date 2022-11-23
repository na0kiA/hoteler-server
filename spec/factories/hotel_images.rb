# frozen_string_literal: true

FactoryBot.define do
  factory :hotel_image do
    sequence(:key) { |n| "aws/s3/keys1998/#{n}" }

    trait :with_completed_profile_hotel do
      sequence(:key) { |n| "aws/s3/accepted/#{n}" }
    end
  end

  # factory :hotel_image do
  #   sequence(:key) { |n| "aws/s3/keys1998/#{n}" }

  #   trait :with_completed_profile_hotel do
  #     sequence(:key) { |n| "aws/s3/accepted/#{n}" }
  #     association :hotel, factory: :completed_profile_hotel
  #   end
  # end
end

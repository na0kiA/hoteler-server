# frozen_string_literal: true

FactoryBot.define do
  factory :hotel_image do
    sequence(:key) { 'aws/s3/keys/1998' }
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :hotel_image do
    key { "aws/s3/keys/199" }
    # association :hotel, factory: :completed_profile_hotel
  end
end

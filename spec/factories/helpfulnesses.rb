# frozen_string_literal: true

FactoryBot.define do
  factory :helpfulness do
    sequence(:id) { |n| n }
    # sequence(:user_id) { |n| n }
    # sequence(:review_id) { |n| "hotel_content#{n}" }
  end
end

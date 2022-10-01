# frozen_string_literal: true

FactoryBot.define do
  factory :hotel do
    sequence(:accepted) { false }
    sequence(:name) { |n| "hotel#{n}" }
    sequence(:content) { |n| "hotel_content#{n}" }
  end
  factory :accepted_hotel, class: 'Hotel' do
    sequence(:accepted) { true }
    sequence(:name) { |n| "hotel#{n}" }
    sequence(:content) { |n| "hotel_content#{n}" }
  end
end

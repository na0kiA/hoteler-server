FactoryBot.define do
  factory :hotel do
    # sequence(:id) { |n| "#{n}" }
    # sequence(:user_id) { |n| "#{n}" }
    sequence(:name) { |n| "hotel#{n}" }
    sequence(:content) { |n| "hotel_content#{n}" }
  end
  factory :accepted_hotel, class: 'Hotel' do
    sequence(:accepted) { true }
    sequence(:name) { |n| "hotel#{n}" }
    sequence(:content) { |n| "hotel_content#{n}" }
  end
end

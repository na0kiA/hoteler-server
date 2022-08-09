FactoryBot.define do
  factory :review do
    sequence(:title) { |n| "review_title#{n}" }
    sequence(:content) { |n| "review_content#{n}" }
  end
end

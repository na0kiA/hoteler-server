FactoryBot.define do
  factory :image do
    sequence(:hotel_s3_key) { |n| "uploads/hoteler/test/test#{n}.jpg" }
  end
end

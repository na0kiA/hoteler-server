require 'factory_bot'
require_relative "./samples.rb"
include FactoryBot::Syntax::Methods


one_to_nine = (1..9).to_a.sample


10.times do |i|
  hotel = create(
    :with_service_completed_hotel,
    :with_user,
    name: hotel_names.sample,
    content: "
#{hotel_content.sample}

#{hotel_fee.sample}
",
    accepted: true,
    created_at: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now, format: :default),
    updated_at: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now, format: :default),
    favorites_count: Faker::Number.number(digits: 2),
    full: Faker::Boolean.boolean(true_ratio: 0.2),
    prefecture: Faker::Address.state,
    city: Faker::Address.city,
    postal_code: Faker::Address.postcode,
    street_address: "#{(1..9).to_a.sample}の#{(11..50).to_a.sample}",
    phone_number: Faker::PhoneNumber.phone_number,
    company: Faker::Name.first_name + Faker::Company.suffix
  )

  (5..8).to_a.sample.times do
    create(:hotel_image , hotel_id: hotel.id, key: "uploads/hoteler/4786f605-a290-4849-929f-cafbacb46beb/hotel-top-#{(0..119).to_a.sample}.jpg")
  end

  other_user = create_list(:other_user, 20)
  p other_user
  p other_user.sample
  other_user1 = create_list(:other_user, 50)
  other_user2 = create_list(:other_user, 80)

  (1..2).to_a.sample.times do
    create(:review, hotel_id: hotel.id, five_star_rate: (1..2).to_a.sample, title: one_or_two_reviews_title.sample, content: two_or_one_reviews_content.sample, user: other_user.sample )
  end

  (2..3).to_a.sample.times do
    create(:review, hotel_id: hotel.id, five_star_rate: 3, title: three_reviews_title.sample, content: three_reviews_content.sample, user: other_user1.sample )
  end

  (3..9).to_a.sample.times do
    create(:review, hotel_id: hotel.id, five_star_rate: (4..5).to_a.sample, title: five_or_four_reviews_title.sample, content: five_or_four_reviews_content.sample, user: other_user2.sample)
  end
end

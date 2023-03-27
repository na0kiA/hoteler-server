require 'factory_bot'
require_relative "./samples.rb"
include FactoryBot::Syntax::Methods


one_to_nine = (1..9).to_a.sample


100.times do |i|
  hotel = create(
    :with_random_service_completed_hotel,
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
    full: Faker::Boolean.boolean(true_ratio: 0.3),
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

    create(:hotel_facility, hotel_id: hotel.id, wifi_enabled: Faker::Boolean.boolean(true_ratio: 0.5), parking_enabled: Faker::Boolean.boolean(true_ratio: 0.5),  breakfast_enabled: Faker::Boolean.boolean(true_ratio: 0.5), credit_card_enabled: Faker::Boolean.boolean(true_ratio: 0.5), phone_reservation_enabled: Faker::Boolean.boolean(true_ratio: 0.5), net_reservation_enabled: Faker::Boolean.boolean(true_ratio: 0.5), triple_rooms_enabled: Faker::Boolean.boolean(true_ratio: 0.5), secret_payment_enabled: Faker::Boolean.boolean(true_ratio: 0.5), cooking_enabled: Faker::Boolean.boolean(true_ratio: 0.5), coupon_enabled: Faker::Boolean.boolean(true_ratio: 0.5))

  (1..4).to_a.sample.times do
    sample_user = create(:sample_user, name: user_name.sample)
    create(:review, hotel_id: hotel.id, five_star_rate: (1..2).to_a.sample, title: one_or_two_reviews_title.sample, content: two_or_one_reviews_content.sample, user: sample_user )
  end

  (3..9).to_a.sample.times do
    sample_user = create(:sample_user, name: user_name.sample)
    create(:review, hotel_id: hotel.id, five_star_rate: 3, title: three_reviews_title.sample, content: three_reviews_content.sample, user: sample_user)
  end

  (5..20).to_a.sample.times do
    sample_user = create(:sample_user, name: user_name.sample)
    create(:review, hotel_id: hotel.id, five_star_rate: (4..5).to_a.sample, title: five_or_four_reviews_title.sample, content: five_or_four_reviews_content.sample, user: sample_user)
  end
end

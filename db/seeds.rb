include FactoryBot::Syntax::Methods

  hotel = Hotel.create_list(
    :completed_profile_hotel,
    :with_user,
    :with_service_rates,
    :with
    user: User.fitst,
    name: Faker::JapaneseMedia::StudioGhibli.unique.character,
    content: "当ホテルでは",
    accepted: true,
    created_at: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now, format: :default),
    updated_at: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now, format: :default),
    favorites_count: Faker::Number.number(digits: 2),
    full: Faker::Boolean.boolean(true_ratio: 0.2),
    prefecture: Faker::Address.state,
    city: Faker::Address.city,
    postal_code: Faker::Address.postcode,
    street_address: Faker::Address.street_address,
    phone_number: Faker::PhoneNumber.phone_number,
    company: Faker::Name.first_name + Faker::Company.suffix
  )

  hotel.hotel_images.key

  (1..5).to_a.sample.times do
    Review.create(hotel_id: hotel.id, rating: (1..5).to_a.sample, title: Faker::Lorem.word, body: Faker::Lorem.paragraph, user: User.all.sample)
  end

end

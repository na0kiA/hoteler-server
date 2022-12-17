include FactoryBot::Syntax::Methods

2.times do |i|
  hotel = create(
    :with_service_completed_hotel,
    :with_user,
    name: Faker::JapaneseMedia::StudioGhibli.unique.character,
    content: "【お客様各位】
    当ホテルへのご来店誠にありがとうございます。",
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

  (1..2).to_a.sample.times do
    create(:review, hotel_id: hotel.id, five_star_rate: (1..2).to_a.sample, title: "正直あまり良くなかった", content: "値段の割にはそこまででした。", user_id: create(:other_user).id)
  end
  (2..3).to_a.sample.times do
    create(:review, hotel_id: hotel.id, five_star_rate: (3..4).to_a.sample, title: "普通に良かったです", content: "部屋が綺麗でした。また利用しようと思っています。", user_id: create(:other_user2).id)
  end
  (2..6).to_a.sample.times do
    create(:review, hotel_id: hotel.id, five_star_rate: 5, title: "最高でした", content: "フロントの対応もよくて、アメニティも豊富で良かったです。", user_id: create(:other_user3).id)
  end
end

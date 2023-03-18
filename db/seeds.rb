require 'factory_bot'
include FactoryBot::Syntax::Methods

2.times do |i|
  hotel = create(
    :with_service_completed_hotel,
    :with_user,
    name: Faker::JapaneseMedia::StudioGhibli.unique.character,
    content: "【お客様各位】
    当ホテルへのご来店誠にありがとうございます。
    日曜日～木曜日・祝日】
1部　19時～翌12時
2部　21時～翌14時
￥5,600～￥7,500

【金曜日】
21時～翌12時
￥7,500～￥9,500

【土曜日・祝前日】
21時～翌12時
￥ 11,000～￥13,000


休憩
休憩60分
【月曜日～金曜日】
￥2,700～￥3,100
【土曜日・日曜日・祝日】
￥3,700～￥4,100

休憩3時間
【月曜日～金曜日】
￥3,600～￥4,000
【土曜日・日曜日・祝日】
￥5,100～￥5,500

※6時～24時の間の利用に限る
サービスタイム
【月曜日～金曜日】
1部　6:00～18:00
2部　15:00～21:00
￥4,600～￥5,100

【土曜日・日曜日・祝日】
1部　6:00～18:00
2部　15:00～21:00
￥6,600～7,100
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

  # (1..2).to_a.sample.times do
  #   create(:hotel_image , hotel_id: hotel.id, key: "uploads/hoteler/4786f605-a290-4849-929f-cafbacb46beb/hoteler_demo_photo.jpg")
  # end

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

10.times do |n|
  Hotel.create!(
    name: "ホテル#{n + 1}",
    content: "ホテル情報#{n + 1}",
    user_id: 1,
    accepted: false
  )
end
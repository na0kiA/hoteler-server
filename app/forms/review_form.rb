class ReviewForm
  include ActiveModel::Model

  attr_accessor :title, :content, :five_star_rate, :user_id, :hotel_id

  with_options presence: true do
    validates :five_star_rate,numericality: { in: 1..5 }, length: {maximum: 3}
    with_options invalid_words: true do
      validates :title, length: { minimum: 2, maximum: 1000 }
      validates :content, length: { minimum: 10, maximum: 1000 }
    end
  end

    def save
      Review.create!(title: title, content: content, five_star_rate: five_star_rate, hotel_id: hotel_id, user_id: user_id)
    end
end

class ReviewForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :title, :string
  attribute :content, :string
  attribute :five_star_rate, :integer
  attribute :key, :string
  attribute :hotel_id, :integer
  attribute :user_id, :integer

  with_options presence: true do
    validates :five_star_rate, inclusion: { in: [1, 2, 3, 4, 5] }
    with_options invalid_words: true do
      validates :title, length: { minimum: 2, maximum: 30 }
      validates :content, length: { minimum: 5, maximum: 1000 }
    end
  end

  def save
    return if invalid?

    ActiveRecord::Base.transaction do
      review = Review.new(title:, content:, five_star_rate:, hotel_id:, user_id:)
      if key.present?
        JSON.parse(key).each do |val|
          review.review_images.build(key: val)
        end
      end
      review.save!
      review.hotel.update!(reviews_count: Review.where(hotel_id:).count)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  def params
    attributes.deep_symbolize_keys
  end
end

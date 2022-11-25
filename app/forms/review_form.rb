# frozen_string_literal: true

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
      build_key(review:)
      send_notification_when_create
      review.save!
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  def to_deep_symbol
    attributes.deep_symbolize_keys
  end

  def too_many_images?
    return if key.blank?

    JSON.parse(key).length > 3
  end

  private

    def build_key(review:)
      return if key.blank?

      JSON.parse(key).each do |val|
        review.review_images.build(key: val)
      end
    end

    def send_notification_when_create
      Notification.create(kind: "came_reviews", message: title, sender_id: user_id, hotel_id:, user_id: hotel_manager_id)
    end

    def hotel_manager_id
      Hotel.find_by(id: hotel_id).user_id
    end
end

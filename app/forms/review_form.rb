class ReviewForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  # attr_accessor :five_star_rate

  # attr_reader :review, :review_images

  attribute :title, :string
  attribute :content, :string
  attribute :five_star_rate, :integer
  attribute :key, :string
  attribute :file_url, :string
  attribute :hotel_id, :integer
  attribute :user_id, :integer

  with_options presence: true do
    validates :five_star_rate, inclusion: { in: [1, 2, 3, 4, 5] }
    with_options invalid_words: true do
      validates :title, length: { minimum: 2, maximum: 30 }
      validates :content, length: { minimum: 5, maximum: 1000 }
    end
  end

  def initialize(user_id:, hotel_id:, attributes: nil, review: nil)
    attributes ||= default_attributes
    @review = review || Review.new(user_id:, hotel_id:)

    # Active Modelのinitializeを引数attributesで呼び出している
    # 結果として書き込みメソッドを用いてtitleなどを書き込んでいる
    super(attributes)
  end

  def save
    return if invalid?

    ActiveRecord::Base.transaction do
      review.update!(title:, content:, five_star_rate:)
      review_images = ReviewImage.find_or_create_by!(review_id: review.id)
      review_images.update!(key:, file_url:)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  attr_reader :review, :review_images

  def default_attributes
    {
      title: review.title,
      content: review.content,
      five_star_rate: review.five_star_rate,
      key: review.review_images.pluck(:key),
      file_url: review.review_images.pluck(:file_url),
      hotel_id: review.hotel_id,
      user_id: review.user_id
    }
  end
end

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

  def save(params)
    return if invalid?

    ActiveRecord::Base.transaction do
      review = Review.new(name: params[:name], content: params[:content], user_id: params[:user_id])
      JSON.parse(params[:key]).each do |val|
        review.review_images.build(key: val, file_url: params[:file_url])
      end
      review.save!
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  def params
    attributes.deep_symbolize_keys
  end
end

class ReviewForm
  include ActiveModel::Model
  # include ActiveModel::Attributes

  # attribute :title, :string
  # attribute :content, :string
  # attribute :five_star_rate, :decimal
  # attribute :user_id, :integer
  # attribute :hotel_id, :integer
  attr_accessor :title, :content, :five_star_rate, :user_id, :hotel_id

  with_options presence: true do
    validates :five_star_rate, numericality: {less_than_or_equal_to: 5, greater_than_or_equal_to: 1}
    with_options invalid_words: true do
      validates :title, length: { minimum: 2, maximum: 1000 }
      validates :content, length: { minimum: 10, maximum: 1000 }
    end
  end

    def save(params)
      Review.create!(title: params[:title], content: params[:content], five_star_rate: params[:five_star_rate].to_i, hotel_id: params[:hotel_id], user_id: params[:user_id])
    end
end

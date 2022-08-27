class ReviewForm
  include ActiveModel::Model

  attr_accessor :title, :content, :five_star_rate, :user_id, :hotel_id, :attributes

  with_options presence: true do
    validates :five_star_rate, numericality: { in: 1..5 }, length: { maximum: 3 }
    with_options invalid_words: true do
      validates :title, length: { minimum: 2, maximum: 1000 }
      validates :content, length: { minimum: 10, maximum: 1000 }
    end
  end

  def initialize(attributes:, review: nil, user_id:, hotel_id:)

    attributes = default_attributes if attributes.empty?
    @review = review || Review.new(user_id:, hotel_id:)
    super(attributes)
    # Active Modelのinitializeを引数attributesで呼び出している
    # 結果として書き込みメソッドを用いてtitleなどを書き込んでいる

    # pp attributes
      #<ActionController::Parameters {"title"=>"hotelName", "content"=>"Kobe Kitanosaka is location", "five_star_rate"=>"5", "user_id"=>970, "hotel_id"=>1183} permitted: true>

      # p default_attributes
      # => {:title=>nil, :content=>nil, :five_star_rate=>0.0, :hotel_id=>1192, :user_id=>977}
  end

  
  def save
    return if invalid?

      # p default_attributes
      # => {:title=>nil, :content=>nil, :five_star_rate=>0.0, :hotel_id=>1192, :user_id=>977}

    #このupdateでreview.newしたnilの値にattributesの値を挿入

    # review.update!(title: title, content: content, five_star_rate: five_star_rate, hotel_id: hotel_id, user_id: user_id)

    review.update!(title: title, content: content, five_star_rate: five_star_rate)

    rescue ActiveRecord::RecordInvalid
      false
  end

  # def update(params)
  #   self.attributes = params
  #   save
  # end
  
  # def save
  #   return if invalid?

  #   Review.create!(title:, content:, five_star_rate:, hotel_id:, user_id:)
  # end
  private
  
  attr_reader :review

  #createの場合はデフォルトでnilになる
  #updateの場合はコントローラーの@reviewが挿入される？
  def default_attributes
    { 
      title: review.title,
      content: review.content,
      five_star_rate: review.five_star_rate,
      hotel_id: review.hotel_id,
      user_id: review.user_id
     }
  end
end

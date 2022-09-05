class HotelForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_reader :hotel, :hotel_images

  attribute :name, :string
  attribute :content, :string
  attribute :key, :string
  attribute :file_url, :string
  attribute :user_id, :integer

  with_options presence: true do
    with_options invalid_words: true do
      validates :name, length: { maximum: 50 }
      validates :content, length: { minimum: 10, maximum: 2000 }
    end
    validates :key, length: { minimum: 10 }
    validates :file_url, length: { minimum: 10 }
    validates :user_id
  end

  def initialize(user_id:, attributes:, hotel: nil, hotel_images: nil)
    @hotel = hotel || Hotel.new(user_id:)
    @hotel_images = hotel_images || HotelImage.new(hotel_id: @hotel.id)
    super(attributes)
  end

  def save
    return if invalid?

    ActiveRecord::Base.transaction do
      hotel.update!(name: name, content: content)
      hotel_images.update!(hotel_id: hotel.id, key:, file_url:)
      # JSON.parse(key).each do |val|
        # HotelImage.find_or_create_by(hotel_id: hotel.id, key: val, file_url:)
      # end
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  def update
    return if invalid?

    ActiveRecord::Base.transaction do
      hotel.update!(name:, content:)
      JSON.parse(key).each do |val|
        hotel_images.update!(hotel_id: hotel.id, key: val, file_url:)
      end
    end
  rescue ActiveRecord::RecordInvalid
    false
  end
end

class HotelForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :content, :string
  attribute :key, :string
  attribute :file_url, :string
  attribute :user_id, :integer

  with_options presence: true do
    with_options invalid_words: true do
      validates :name, length: { maximum: 50 }
      validates :content, length: { minimum: 10, maximum: 2000 }
      validates :key, length: { minimum: 10 }
    end
    validates :file_url, length: { minimum: 10 }
    validates :user_id
  end

  def initialize(user_id:, attributes: nil, hotel: nil)
    attributes ||= default_attributes
    @hotel = hotel || Hotel.new(user_id:)

    super(attributes)
  end

  def save
    return if invalid?

    ActiveRecord::Base.transaction do
      hotel.update!(name:, content:)
      hotel.hotel_images.update!(key:, file_url:)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  attr_reader :hotel, :hotel_images

  def default_attributes
    {
      name: hotel.name,
      content: hotel.content,
      key: hotel.hotel_images.pluck(:key),
      file_url: hotel.hotel_images.pluck(:file_url),
      user_id: hotel.user_id
    }
  end
end

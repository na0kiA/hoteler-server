class HotelForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :content, :string
  attribute :key, :string
  attribute :user_id, :integer

  attribute :day, :integer
  attribute :rest, :string

  # attribute :lodging_rate, :integer
  # attribute :first_lodging_time, :time
  # attribute :last_lodging_time, :time


  with_options presence: true do
    with_options invalid_words: true do
      validates :name, length: { maximum: 50 }
      validates :content, length: { minimum: 10, maximum: 2000 }
    end
    validates :key, length: { minimum: 10 }
    validates :user_id
  end

  def save
    return if invalid?

    ActiveRecord::Base.transaction do
      hotel = Hotel.new(name:, content:, user_id:)
      JSON.parse(key).each do |val|
        hotel.hotel_images.build(key: val)
      end
      build_daily_rate(hotel:)
      hotel.save!
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  def to_deep_symbol
    attributes.deep_symbolize_keys
  end

  private

  def build_daily_rate(hotel:)
    rates = hotel.hotel_daily_rates.build(rest:)
    rates.monday_through_thursday! if rest.starts_with?("月曜から木曜")
    rates.friday! if rest.starts_with?("金曜")
    rates.saturday! if rest.starts_with?("土曜")
    rates.sunday! if rest.starts_with?("日曜")
    rates.special_day! if rest.starts_with?("特別期間")
  end
end

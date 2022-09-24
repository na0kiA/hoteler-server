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
    if rest.starts_with?("月曜から木曜")
      hotel.hotel_daily_rates.build(rest:, day: :monday_through_thursday)
    elsif rest.starts_with?("金曜")
      hotel.hotel_daily_rates.build(rest:, day: :friday)
    elsif rest.starts_with?("土曜")
      hotel.hotel_daily_rates.build(rest:, day: :saturday)
    elsif rest.starts_with?("日曜")
      hotel.hotel_daily_rates.build(rest:, day: :sunday)
    elsif rest.starts_with?("特別期間")
      hotel.hotel_daily_rates.build(rest:, day: :special_day)
    end
  end

  def create_rest
    hotel
  end
end

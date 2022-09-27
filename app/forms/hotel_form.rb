class HotelForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :content, :string
  attribute :key, :string
  attribute :user_id, :integer

  attribute :day, :string
  attribute :rates_for_the_day

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
      p hotel.days.build(:day)
      JSON.parse(key).each do |val|
        hotel.hotel_images.build(key: val)
      end
      hotel.save!
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  def to_deep_symbol
    attributes.deep_symbolize_keys
  end

  private


  def build_daily_rest_rates(day:)
    day_of_week = hotel.days.build(day:)
    day_of_week.rest_rates.build()
  end

  # def switch_enum_of_day(rates:)
  #   rates.monday_through_thursday! if day_of_week.starts_with?('月曜から木曜')
  #   rates.friday! if day_of_week.starts_with?('金曜')
  #   rates.saturday! if day_of_week.starts_with?('土曜')
  #   rates.sunday! if day_of_week.starts_with?('日曜')
  #   rates.special_day! if day_of_week.starts_with?('特別期間')
  # end

  # def pick_lodging_hours(first_lodging_time:, last_lodging_time:)
  #   Rails.logger.debug (I18n.l first_lodging_time, format: :hours).to_i
  #   Rails.logger.debug (I18n.l last_lodging_time, format: :hours).to_i
  # end

  # def stay_night_time?(now = Time.current)
  #   first = (I18n.l first_lodging_time, format: :hours).to_i
  #   last = (I18n.l last_lodging_time, format: :hours).to_i

  #   [*first..23, *0..last].include?(now)
  # end
end

# frozen_string_literal: true

class HotelForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :content, :string
  attribute :key, :string
  attribute :user_id, :integer

  attribute :day, :string
  attribute :daily_rates

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
      build_hotel_images(hotel:)
      build_today_rest_rate(today: build_day(hotel:))
      hotel.save!
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  def to_deep_symbol
    attributes.deep_symbolize_keys
  end

  private

    def build_hotel_images(hotel:)
      JSON.parse(key).each do |val|
        hotel.hotel_images.build(key: val)
      end
    end

    def build_day(hotel:)
      hotel.days.build(day: daily_rates[:day])
    end

    def build_today_rest_rate(today:)
      today.rest_rates.build(plan: rest[:plan], rate: rest[:rate], first_time: rest[:first_time], last_time: rest[:last_time])
    end

    def rest
      daily_rates.fetch(:rest_rates)
    end
end

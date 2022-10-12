# frozen_string_literal: true

class HotelForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :content, :string
  attribute :key, :string
  attribute :user_id, :integer
  attribute :friday
  attribute :saturday

  attribute :friday_rates
  attribute :day, :string

  attribute :special_periods

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
    p friday
    p saturday

    ActiveRecord::Base.transaction do
      hotel = Hotel.new(name:, content:, user_id:)
      build_hotel_images(hotel:)
      build_friday_rest_rates(today: build_friday(hotel:))
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

    def build_friday_rest_rates(today:)
      today.rest_rates.build(plan: friday_rest[:plan][0], rate: friday_rest[:rate][0], first_time: friday_rest[:first_time][0], last_time: friday_rest[:last_time][0])
    end

    def build_friday(hotel:)
      hotel.days.build(day: friday_rates[:day])
    end

    def build_friday_rest_rate(today:)
      today.rest_rates.build(plan: friday_rest[:plan], rate: friday_rest[:rate], first_time: friday_rest[:first_time], last_time: friday_rest[:last_time])
    end

    def friday_rest
      friday_rates.fetch(:rest_rates)
    end
end

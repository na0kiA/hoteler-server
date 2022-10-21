# frozen_string_literal: true

class HotelForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :content, :string
  attribute :key, :string
  attribute :user_id, :integer

  attribute :daily_rates
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

    ActiveRecord::Base.transaction do
      hotel = Hotel.new(name:, content:, user_id:)
      build_hotel_images(hotel:)

      build_monday_through_thursday_rate(hotel:)
      build_friday_rate(hotel:)
      build_saturday_rate(hotel:)
      build_sunday_rate(hotel:)
      build_holiday_rate(hotel:)
      build_day_before_a_holiday_rate(hotel:)
      build_special_days_rate(hotel:)
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

    def build_monday_through_thursday_rate(hotel:)
      day = hotel.days.build(day: '月曜から木曜')
      daily_rates.dig(:monday_through_thursday, :rest_rates).map do |val|
        day.rest_rates.build(plan: val[:plan], rate: val[:rate], first_time: val[:first_time],  last_time: val[:last_time])
      end
    end

    def build_friday_rate(hotel:)
      day = hotel.days.build(day: '金曜')
      daily_rates.dig(:friday, :rest_rates).map do |val|
        day.rest_rates.build(plan: val[:plan], rate: val[:rate], first_time: val[:first_time],  last_time: val[:last_time])
      end
    end

    def build_saturday_rate(hotel:)
      day = hotel.days.build(day: '土曜')
      daily_rates.dig(:saturday, :rest_rates).map do |val|
        day.rest_rates.build(plan: val[:plan], rate: val[:rate], first_time: val[:first_time],  last_time: val[:last_time])
      end
    end

    def build_sunday_rate(hotel:)
      day = hotel.days.build(day: '日曜')
      daily_rates.dig(:sunday, :rest_rates).map do |val|
        day.rest_rates.build(plan: val[:plan], rate: val[:rate], first_time: val[:first_time],  last_time: val[:last_time])
      end
    end

    def build_holiday_rate(hotel:)
      day = hotel.days.build(day: '祝日')
      daily_rates.dig(:holiday, :rest_rates).map do |val|
        day.rest_rates.build(plan: val[:plan], rate: val[:rate], first_time: val[:first_time],  last_time: val[:last_time])
      end
    end

    def build_day_before_a_holiday_rate(hotel:)
      day = hotel.days.build(day: '祝前日')
      daily_rates.dig(:day_before_a_holiday, :rest_rates).map do |val|
        day.rest_rates.build(plan: val[:plan], rate: val[:rate], first_time: val[:first_time],  last_time: val[:last_time])
      end
    end

    def build_special_days_rate(hotel:)
      day = hotel.days.build(day: '特別期間')
      build_special_periods(special_day: day)
      daily_rates.dig(:special_days, :rest_rates).map do |val|
        day.rest_rates.build(plan: val[:plan], rate: val[:rate], first_time: val[:first_time],  last_time: val[:last_time])
      end
    end

    def special_day_array
      special_periods.values_at(:obon, :golden_week, :the_new_years_holiday)
    end

    def build_special_periods(special_day:)
      special_day_array.map do |val|
        special_day.special_periods.build(period: val[:period], start_date: val[:start_date], end_date: val[:end_date])
      end
    end
end

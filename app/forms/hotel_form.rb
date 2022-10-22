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
    validates :daily_rates
  end

  def save
    return if invalid?

    ActiveRecord::Base.transaction do
      hotel = Hotel.new(name:, content:, user_id:)
      build_hotel_images(hotel:)
      build_all_rest_rate(hotel:)
      build_special_days_rate(hotel:)
      hotel.save!
      p each_rest_rate_array.friday
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

    def normal_period_array
      daily_rates.values_at(:monday_through_thursday, :friday, :saturday, :sunday, :holiday, :day_before_a_holiday, :special_days)
    end

    DailyRate = Struct.new(:monday_through_thursday, :friday, :saturday, :sunday, :holiday, :day_before_a_holiday)

    def each_rest_rate_array
      arr = []
      normal_period_array.map do |period|
        arr << period.fetch(:rest_rates)
      end
      DailyRate.new(arr[0], arr[1], arr[2], arr[3], arr[4], arr[5])
    end



    def build_rest_rate(day:, each_rest_rate:)
      day.rest_rates.build(plan: each_rest_rate[:plan], rate: each_rest_rate[:rate], first_time: each_rest_rate[:first_time], last_time: each_rest_rate[:last_time])
    end

    def build_all_rest_rate(hotel:)
      monday_through_thursday, friday, saturday, sunday, holiday, day_before_a_holiday = hotel.days.build([{ day: '月曜から木曜' }, { day: '金曜' }, { day: '土曜' }, { day: '日曜' }, { day: '祝日' }, { day: '祝前日' }])

      daily_rates.dig(:monday_through_thursday, :rest_rates).map do |each_rest_rate|
        build_rest_rate(day: monday_through_thursday, each_rest_rate:)
      end

      daily_rates.dig(:friday, :rest_rates).map do |each_rest_rate|
        build_rest_rate(day: friday, each_rest_rate:)
      end

      daily_rates.dig(:saturday, :rest_rates).map do |each_rest_rate|
        build_rest_rate(day: saturday, each_rest_rate:)
      end

      daily_rates.dig(:sunday, :rest_rates).map do |each_rest_rate|
        build_rest_rate(day: sunday, each_rest_rate:)
      end

      daily_rates.dig(:holiday, :rest_rates).map do |each_rest_rate|
        build_rest_rate(day: holiday, each_rest_rate:)
      end

      daily_rates.dig(:day_before_a_holiday, :rest_rates).map do |each_rest_rate|
        build_rest_rate(day: day_before_a_holiday, each_rest_rate:)
      end
    end

    def build_special_days_rate(hotel:)
      day = hotel.days.build(day: '特別期間')
      build_special_periods(special_day: day)
      daily_rates.dig(:special_days, :rest_rates).map do |each_rest_rate|
        build_rest_rate(day:, each_rest_rate:)
      end
    end

    def special_day_array
      return if special_periods.blank?

      special_periods.values_at(:obon, :golden_week, :the_new_years_holiday)
    end

    def build_special_periods(special_day:)
      return if special_periods.blank?

      special_day_array.map do |val|
        special_day.special_periods.build(period: val[:period], start_date: val[:start_date], end_date: val[:end_date])
      end
    end
end

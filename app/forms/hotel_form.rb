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

      build_monday_through_thursday_rest_rates(day: hotel.days.build(day: '月曜から木曜'))
      build_friday_rest_rates(day: hotel.days.build(day: '金曜'))
      build_saturday_rest_rates(day: hotel.days.build(day: '土曜'))
      build_sunday_rest_rates(day: hotel.days.build(day: '日曜'))
      build_holiday_rest_rates(day: hotel.days.build(day: '祝日'))
      build_day_before_a_holiday_rest_rates(day: hotel.days.build(day: '祝前日'))
      build_special_day_rest_rates(day: hotel.days.build(day: '特別期間'))
      # binding.break
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

    def build_monday_through_thursday_rest_rates(day:)
      monday_through_thursday_rest_rate.size.times do |val|
        day.rest_rates.build(plan: monday_through_thursday_rest_rate[val][:plan], rate: monday_through_thursday_rest_rate[val][:rate], first_time: monday_through_thursday_rest_rate[val][:first_time],
                             last_time: monday_through_thursday_rest_rate[val][:last_time])
      end
    end

    def build_friday_rest_rates(day:)
      friday_rest_rate.size.times do |val|
        day.rest_rates.build(plan: friday_rest_rate[val][:plan], rate: friday_rest_rate[val][:rate], first_time: friday_rest_rate[val][:first_time], last_time: friday_rest_rate[val][:last_time])
      end
    end

    def build_saturday_rest_rates(day:)
      saturday_rest_rate.size.times do |val|
        day.rest_rates.build(plan: saturday_rest_rate[val][:plan], rate: saturday_rest_rate[val][:rate], first_time: saturday_rest_rate[val][:first_time],
                             last_time: saturday_rest_rate[val][:last_time])
      end
    end

    def build_sunday_rest_rates(day:)
      sunday_rest_rate.size.times do |val|
        day.rest_rates.build(plan: sunday_rest_rate[val][:plan], rate: sunday_rest_rate[val][:rate], first_time: sunday_rest_rate[val][:first_time], last_time: sunday_rest_rate[val][:last_time])
      end
    end

    def build_holiday_rest_rates(day:)
      holiday_rest_rate.size.times do |val|
        day.rest_rates.build(plan: holiday_rest_rate[val][:plan], rate: holiday_rest_rate[val][:rate], first_time: holiday_rest_rate[val][:first_time], last_time: holiday_rest_rate[val][:last_time])
      end
    end

    def build_day_before_a_holiday_rest_rates(day:)
      day_before_a_holiday_rest_rate.size.times do |val|
        day.rest_rates.build(plan: day_before_a_holiday_rest_rate[val][:plan], rate: day_before_a_holiday_rest_rate[val][:rate], first_time: day_before_a_holiday_rest_rate[val][:first_time],
                             last_time: day_before_a_holiday_rest_rate[val][:last_time])
      end
    end

    def build_special_day_rest_rates(day:)
      special_day_rest_rate.size.times do |val|
        day.rest_rates.build(plan: special_day_rest_rate[val][:plan], rate: special_day_rest_rate[val][:rate], first_time: special_day_rest_rate[val][:first_time],
                             last_time: special_day_rest_rate[val][:last_time])
      end
    end

    def monday_through_thursday_rest_rate
      daily_rates.dig(:monday_through_thursday, :rest_rates)
    end

    def friday_rest_rate
      daily_rates.dig(:friday, :rest_rates)
    end

    def saturday_rest_rate
      daily_rates.dig(:saturday, :rest_rates)
    end

    def sunday_rest_rate
      daily_rates.dig(:sunday, :rest_rates)
    end

    def holiday_rest_rate
      daily_rates.dig(:holiday, :rest_rates)
    end

    def day_before_a_holiday_rest_rate
      daily_rates.dig(:day_before_a_holiday, :rest_rates)
    end

    def special_day_rest_rate
      daily_rates.dig(:special_days, :rest_rates)
    end

    def extract_all_rest_rate_array
      normal_period_array.pluck(:rest_rates)
    end

    def normal_period_array
      daily_rates.values_at(:monday_through_thursday, :friday, :saturday, :sunday, :holiday, :day_before_a_holiday, :special_days)
    end

    def special_day_array
      special_periods.values_at(:obon, :golden_week, :the_new_years_holiday)
    end

    def build_special_periods(hotel:)
      special_day_array.map do |val|
        special_day = hotel.days.build(day: '特別期間')
        special_day.special_periods.build(period: val[:period], start_date: val[:start_date], end_date: val[:end_date])
      end
    end
end

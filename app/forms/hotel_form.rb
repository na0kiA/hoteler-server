# frozen_string_literal: true

class HotelForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :content, :string
  attribute :key, :string
  attribute :user_id, :integer

  attribute :daily_rates, :daily_rate_array, default: []

  with_options presence: true do
    with_options invalid_words: true do
      validates :name, length: { maximum: 50 }
      validates :content, length: { minimum: 10, maximum: 2000 }
    end
    validates :key, length: { minimum: 10 }
    validates :user_id
  end

  DAY_OF_WEEK = [monday_through_thursday: '月曜から木曜', friday: '金曜', saturday: '土曜', sunday: '日曜', holiday: '祝日'].freeze

  def save
    return if invalid?

    Rails.logger.debug daily_rates.first

    ActiveRecord::Base.transaction do
      hotel = Hotel.new(name:, content:, user_id:)
      build_hotel_images(hotel:)
      build_rest_rates_of_all_days(hotel:)
      build_special_periods(special_day: build_hotel_days(hotel:, today: '特別期間'))
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

    # 各曜日ごとに休憩料金をbuild
    def build_rest_rates_of_all_days(hotel:)
      DAY_OF_WEEK.each do |day|
        build_friday_rest_rates(day_of_week: build_hotel_days(hotel:, today: day))
      end
    end

    # 休憩料金を
    def build_today_rest_rates(day_of_week:)
      day_of_week.rest_rates.build(plan: friday_rates[0][:plan], rate: friday_rates[0][:rate], first_time: friday_rates[0][:first_time], last_time: friday_rates[0][:last_time])
    end

    def build_hotel_days(hotel:, today:)
      hotel.days.build(day: today)
    end

    def rates
     # daily_rates.dig(:friday, :rest_rates)
      daily_rates.fetch(:saturday)
      daily_rates.fetch(:sunday)
      daily_rates.fetch(:holiday)
    end

    # def monday_through_thursday_rates
    #   daily_rates.fetch(:monday_through_thursday)
    # end

    def friday_rates
      daily_rates.fetch(:friday)
    end

    # def saturday_rates
    #   daily_rates.fetch(:saturday)
    # end

    # def sunday_rates
    #   daily_rates.fetch(:sunday)
    # end

    # def holiday_rates
    #   daily_rates.fetch(:holiday)
    # end

    def special_period_rates
      special_periods.fetch(:obon)
      special_periods.fetch(:golden_week)
      special_periods.fetch(:the_new_years_holiday)
    end

    def build_special_periods(special_day:)
      # {:obon=>[{:period=>1, :start_date=>"8月9日", :end_date=>"8月15日"}], :golden_week=>[{:period=>0, :start_date=>"5月2日", :end_date=>"5月10日"}], :the_new_years_holiday=>[{:period=>2, :start_date=>"12月25日", :end_date=>"1月4日"}]}
      special_day.special_periods.build(period: special_period_rates[:period], start_date: special_period_rates[:start_date], end_date: special_period_rates[:end_date])
    end
end

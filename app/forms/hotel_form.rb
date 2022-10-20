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

  DAY_OF_WEEK = %w[月曜から木曜 金曜 土曜 日曜 祝日 祝前日 特別期間].freeze

  def save
    return if invalid?

    ActiveRecord::Base.transaction do
      hotel = Hotel.new(name:, content:, user_id:)
      build_hotel_images(hotel:)
      build_all_rest_rate(hotel:)
      build_special_periods(hotel:)

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

    def build_all_day(hotel:)
      hotel.days.build(day: %w[月曜から木曜 金曜 土曜 日曜 祝日 祝前日 特別期間])
    end

    def build_all_rest_rate(hotel:)
      extracy_all_rest_rate_array.map do |val|
        days = build_all_day(hotel:)
        val.size.times do |num|
          days.rest_rates.build(plan: val[num][:plan], rate: val[num][:rate], first_time: val[num][:first_time], last_time: val[num][:last_time])
        end
      end
    end

    def extracy_all_rest_rate_array
      normal_period_rates.pluck(:rest_rates)
    end

    def normal_period_rates
      daily_rates.values_at(:monday_through_thursday, :friday, :saturday, :sunday, :holiday, :day_before_a_holiday, :special_days)
    end

    def special_period_rates
      special_periods.values_at(:obon, :golden_week, :the_new_years_holiday)
    end

    # [{:period=>1, :start_date=>"2022-08-08", :end_date=>"2022-08-15"}, {:period=>0, :start_date=>"2022-05-02", :end_date=>"2022-05-01"}, {:period=>2, :start_date=>"2022-12-25", :end_date=>"2023-01-04"}]

    def build_special_periods(hotel:)
      special_period_rates.map do |val|
        special_day = hotel.days.build(day: '特別期間')
          special_day.special_periods.build(period: val[:period], start_date: val[:start_date], end_date: val[:end_date])
      end
    end
end

# frozen_string_literal: true

class HotelForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :content, :string
  attribute :key, :string
  attribute :user_id, :integer

  attribute :monday_through_thursday
  attribute :friday
  attribute :saturday
  attribute :sunday
  attribute :holiday
  attribute :special_day
  attribute :special_periods

  # attribute :daily_rates

  attribute :special_periods

  with_options presence: true do
    with_options invalid_words: true do
      validates :name, length: { maximum: 50 }
      validates :content, length: { minimum: 10, maximum: 2000 }
    end
    validates :key, length: { minimum: 10 }
    validates :user_id
  end

  DAY_OF_WEEK = [friday: '金曜', monday_through_thursday: '月曜から木曜', saturday: '土曜', sunday: '日曜', holiday: '祝日', special_period: '特別期間'].freeze

  def save
    return if invalid?
    p attributes[:daily_rates]

    ActiveRecord::Base.transaction do
      hotel = Hotel.new(name:, content:, user_id:)
      build_hotel_images(hotel:)
      # build_friday_rest_rates(day_of_week: build_day_of_week(hotel:, today:))
      p today_rest_rates
      today(hotel:)
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

    # def build_today_rest_rates(day_of_week:)
    #   day_of_week.rest_rates.build(plan: friday_rest[:plan], rate: friday_rest[:rate], first_time: friday_rest[:first_time], last_time: friday_rest[:last_time])
    # end

    def build_today_rest_rates(day_of_week:)
      day_of_week.rest_rates.build(plan: today_rest_rates[:plan], rate: today_rest_rates[:rate], first_time: today_rest_rates[:first_time], last_time: today_rest_rates[:last_time])
    end

    # def build_friday(hotel:)
    #   hotel.days.build(day: '金曜')
    # end

    def build_day_of_week(hotel:, today:)
      hotel.days.build(day: today)
    end

    def today(hotel:)
      DAY_OF_WEEK.each do |day|
        build_today_rest_rates(day_of_week: build_day_of_week(hotel:, today: day))
      end
    end

    # def friday_rest
    #   friday.fetch(:rest_rates)
    # end

    def today_rest_rates
      daily_rates.each do |day|
        day.fetch(:rest_rates)
      end
    end

    
end

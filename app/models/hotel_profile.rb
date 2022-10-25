# frozen_string_literal: true

class HotelProfile
  include ActiveModel::Model

  attr_reader :params, :name, :content, :set_hotel, :key, :daily_rates

  def initialize(params:, set_hotel:)
    @params = params
    @name = params.fetch(:name)
    @content = params.fetch(:content)
    @key = params.fetch(:key)
    Rails.logger.debug key
    @daily_rates = params.fetch(:daily_rates)
    @set_hotel = set_hotel
  end

  def update
    return if invalid?

    ActiveRecord::Base.transaction do
      find_or_create_key
      remove_unnecessary_key
      update_monday_through_thursday_rest_rate
      update_hotel
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

    def update_hotel
      Hotel.update!(set_hotel.id, name:, content:)
    end

    def difference_key_array
      set_hotel.hotel_images.pluck(:key).difference(key)
    end

    def find_or_create_key
      key.each do |val|
        set_hotel.hotel_images.find_or_create_by!(key: val)
      end
    end

    def remove_unnecessary_key
      set_hotel.hotel_images.where(key: difference_key_array).delete_all
    end

    DailyRate = Struct.new(:monday_through_thursday, :friday, :saturday, :sunday, :holiday, :day_before_a_holiday, :special_days)

    def rest_rates_by_day_of_the_week
      arr = normal_period_array.map do |period|
        period.fetch(:rest_rates)
      end
      DailyRate.new(arr[0], arr[1], arr[2], arr[3], arr[4], arr[5], arr[6])
    end

    def normal_period_array
      daily_rates.values_at(:monday_through_thursday, :friday, :saturday, :sunday, :holiday, :day_before_a_holiday, :special_days)
    end

  # def update_a_rest_rate(rest_rate_id:, a_rest_rate:)
  #   RestRate.update!(rest_rate_id, plan: a_rest_rate[:plan], rate: a_rest_rate[:rate], first_time: a_rest_rate[:first_time], last_time: a_rest_rate[:last_time])
  # end

    def update_monday_through_thursday_rest_rate
      rest_rates_by_day_of_the_week.monday_through_thursday.each do |a_rest_rate|
        rest_rate = generate_hash(plan: a_rest_rate[:plan], rate: a_rest_rate[:rate], first_time: a_rest_rate[:first_time], last_time: a_rest_rate[:last_time])

        RestRate.update!(rest_rate.keys, rest_rate.values)
      end
    end

    def monday_through_thursday_rest_rate_ids
      set_hotel.rest_rates.where(day_id: set_hotel.days.where(day: '月曜から木曜').ids).ids
    end

    def generate_hash(plan:, rate:, first_time:, last_time:)
      hash = {}
      monday_through_thursday_rest_rate_ids.each do |val|
        hash = { val => { plan:, rate:, first_time:, last_time: } }
      end
      hash
    end
end

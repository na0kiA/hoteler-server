# frozen_string_literal: true

class ExtractTodayService
  attr_reader :hotels
  private :hotels

  def initialize(hotels:)
    @hotels = hotels
  end

  def extract_today_services
    select_services
  end

  private

    def select_services(hotel_and_today_services_list = [])
      return if hotels.is_a?(String)
      
      hotels.map do |hotel|
        hotel_and_today_services_list << extract_open_rest_rate(hotel:) << extract_open_stay_rate(hotel:)
      end
      hotel_and_today_services_list.flatten
    end

    def extract_open_rest_rate(hotel:)
      if SpecialPeriod.check_that_today_is_a_special_period?(hotel:)
        RestBusinessHour.new(date: hotel.rest_rates.where(day_id: Day.special_day.where(hotel_id: hotel.id).ids)).extract_the_rest_rate
      else
        RestBusinessHour.new(date: hotel.rest_rates.where(day_id: Day.select_a_day_of_the_week.where(hotel_id: hotel.id).ids)).extract_the_rest_rate
      end
    end

    def extract_open_stay_rate(hotel:)
      if SpecialPeriod.check_that_today_is_a_last_day_of_special_periods?(hotel:)
        StayBusinessHour.new(stay_rates_of_the_hotel: hotel.stay_rates.where(day_id: Day.select_a_day_of_the_week.where(hotel_id: hotel.id).ids)).extract_the_stay_rate
      else
        StayBusinessHour.new(stay_rates_of_the_hotel: hotel.stay_rates.where(day_id: select_a_day(hotel:).ids)).extract_the_stay_rate
      end
    end

    def select_a_day(hotel:)
      if SpecialPeriod.check_that_today_is_a_special_period?(hotel:)
        Day.special_day.where(hotel_id: hotel.id)
      else
        Day.select_a_day_of_the_week.where(hotel_id: hotel.id)
      end
    end
end

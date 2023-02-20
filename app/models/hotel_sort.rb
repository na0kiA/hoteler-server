# frozen_string_literal: true

class HotelSort
  attr_reader :hotels
  private :hotels

  def initialize(hotels:)
    if hotels.instance_of?(Array)
      @hotels = Hotel.where(id: hotels.map(&:id))
    else
      @hotels = hotels
    end
    # @hotels = hotels
  end

  def sort_by_low_rest
    sort_rest_or_stay(rest_or_stay: select_rest_rates)
  end

  def sort_by_high_rest
    sort_rest_or_stay(rest_or_stay: select_rest_rates).reverse
  end

  def sort_by_low_stay
    sort_rest_or_stay(rest_or_stay: select_stay_rates)
  end

  def sort_by_high_stay
    sort_rest_or_stay(rest_or_stay: select_stay_rates).reverse
  end

  def sort_by_reviews_count
    hotels.eager_load(:hotel_images).sort_by(&:reviews_count)
  end
  
  def select_services(hotel_and_today_services_list = [], sorted_hotels:)
    sorted_hotels.map do |hotel|
      hotel_and_today_services_list << extract_open_rest_rate(hotel:) << extract_open_stay_rate(hotel:)
    end
    hotel_and_today_services_list.flatten
  end

  private

    def sort_rest_or_stay(rest_or_stay:)
      rest_or_stay.eager_load(:hotel, :day).sort_by(&:rate).map(&:hotel)
    end

    def select_rest_rates(rest_rate_box: RestRate.none)
      hotels.eager_load(:days, :rest_rates, :hotel_images).select { |hotel| hotel.rest_rates.present? }.map do |hotel|
        rest_rate_box = rest_rate_box.or(extract_open_rest_rate(hotel:))
      end
      rest_rate_box
    end

    def select_stay_rates(stay_rates_box: StayRate.none)
      hotels.eager_load(:days, :stay_rates, :hotel_images).select { |hotel| hotel.stay_rates.present? }.map do |hotel|
        stay_rates_box = stay_rates_box.or(extract_open_stay_rate(hotel:))
      end
      stay_rates_box
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

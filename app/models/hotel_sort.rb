class HotelSort
  attr_reader :hotels
  private :hotels

  # 現在営業中の休憩料金と宿泊料金から安い順と高い順に並び替える
  
  def initialize(hotels:)
    @hotels = hotels
  end

  def sort_by_low_rest
    sorted_low_rest
  end

  def sort_by_high_rest
    sorted_low_rest.reverse
  end

  def sort_by_low_stay
    sorted_low_stay
  end

  def sort_by_high_stay
    sorted_low_stay.reverse
  end

  private

  def select_rest_rates
    rest_rate_list = RestRate.none
    hotels.map do |hotel|
      next if hotel.rest_rates.blank?

      rest_rate_list = rest_rate_list.or(extract_open_rest_rate(hotel:))
    end
    rest_rate_list
  end

  def extract_open_rest_rate(hotel:)
    if SpecialPeriod.check_that_today_is_a_special_period?(hotel:)
      RestBusinessHour.new(date: hotel.rest_rates.where(day_id: Day.special_day.where(hotel_id: hotel.id).ids)).extract_the_rest_rate
    else
      RestBusinessHour.new(date: hotel.rest_rates.where(day_id: Day.select_a_day_of_the_week.where(hotel_id: hotel.id).ids)).extract_the_rest_rate
    end
  end

  def sorted_low_rest
    hotel = []
    select_rest_rates.preload(:day, :hotel, hotel: :hotel_images).sort_by(&:rate).each do |sorted_rest|
      hotel << sorted_rest.hotel
    end
    hotel
  end

  def select_stay_rates
    stay_rate_list = StayRate.none
    hotels.eager_load(:days, :stay_rates, :hotel_images).map do |hotel|
      next if hotel.stay_rates.blank?

      stay_rate_list = stay_rate_list.or(extract_open_stay_rate(hotel:))
    end
    stay_rate_list
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

  def sorted_low_stay
    hotel = []
    select_stay_rates.eager_load(:hotel, :day).sort_by(&:rate).each do |sorted_stay|
      hotel << sorted_stay.hotel
    end
    hotel
  end

end
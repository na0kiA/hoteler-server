class HotelSort
  attr_reader :hotels
  private :hotels

  # 現在営業中の休憩料金から安い順に並び替えることができる
  
  def initialize(hotels:)
    @hotels = hotels
  end

  def sort_by_low_rest
    sorted_low_rest
  end

  def sort_by_high_rest
    sorted_low_rest.reverse
  end

  private

  def select_rest_rates
    rest_rate_list = RestRate.none
    @hotels.map do |hotel|
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
end
class V1::FiltersController < ApplicationController

  def index
    if search_params[:sort] == "lower_rest"
      render json: sort_by_rest, each_serializer: HotelIndexSerializer
    end
  end

  private

  def filter_params
    params.permit(:sort)
  end

  def select_rest_rates
    rest_rate_list = RestRate.none
    @accepted_hotel.map do |hotel|
      rest_rate_list =  rest_rate_list.or(if SpecialPeriod.check_that_today_is_a_special_period?(hotel:)
                          RestBusinessHour.new(date: hotel.rest_rates.where(day_id: Day.special_day.where(hotel_id: hotel.id).ids)).extract_the_rest_rate
                        else
                          RestBusinessHour.new(date: hotel.rest_rates.where(day_id: Day.select_a_day_of_the_week.where(hotel_id: hotel.id).ids)).extract_the_rest_rate
                        end)
    end
    rest_rate_list
  end

  def sort_by_rest
    hotel = []
    select_rest_rates.preload(:day, :hotel, hotel: :hotel_images).sort_by(&:rate).each do |sorted_rest| 
      hotel << sorted_rest.hotel
    end
    hotel
  end

end

# frozen_string_literal: true

class V1::SearchController < ApplicationController
  def index
    @accepted_hotel = Hotel.accepted
    @hotel = Hotel.none

    if search_params[:keyword].present?
      search_each_params_of_keyword(split_params: split_keyword)

      if sort_by_low_rest?
        render json: sorted_low_rest, each_serializer: HotelIndexSerializer
      elsif @hotel.blank?
        render json: render_not_match_params(search_params[:keyword])
      else
        render json: @hotel, each_serializer: HotelIndexSerializer
      end
    end

    if search_params[:city_and_street_address].present?
      search_each_params_of_city_or_street_address(split_params: split_city_and_street_address)

      if sort_by_low_rest?
        render json: sorted_low_rest, each_serializer: HotelIndexSerializer
      elsif @hotel.blank?
        render json: render_not_match_params(search_params[:city_and_street_address])
      else
        render json: @hotel, each_serializer: HotelIndexSerializer
      end
    end

    if search_params.blank? || (search_params[:keyword].blank? && search_params[:city_and_street_address].blank? && search_params[:sort].blank?)
      redirect_to v1_hotels_path
    end
  end

  private

    def sort_by_low_rest?
      search_params[:sort] == "low_rest"
    end

    def search_each_params_of_city_or_street_address(split_params:)
      split_params.each do |city_and_street_address|
        @hotel = @hotel.or(search_city_and_street_address(city_and_street_address:))
      end
    end

    def search_each_params_of_keyword(split_params:)
      split_params.each do |keyword|
        @hotel = @hotel.or(search_keyword(keyword:))
      end
    end

    def search_keyword(keyword:)
      @accepted_hotel.search_multiple(keyword)
    end

    def search_city_and_street_address(city_and_street_address:)
      @accepted_hotel.search_city_and_street_address(city_and_street_address)
    end

    def render_not_match_params(params)
      "#{params}の検索結果が見つかりませんでした"
    end

    def split_keyword
      search_params[:keyword].split(/[[:blank:]]+/).select(&:present?)
    end

    def split_city_and_street_address
      search_params[:city_and_street_address].split(/[[:blank:]]+/).select(&:present?)
    end

    def select_rest_rates
      rest_rate_list = RestRate.none
      @hotel.map do |hotel|
        rest_rate_list = rest_rate_list.or(if SpecialPeriod.check_that_today_is_a_special_period?(hotel:)
                                             RestBusinessHour.new(date: hotel.rest_rates.where(day_id: Day.special_day.where(hotel_id: hotel.id).ids)).extract_the_rest_rate
                                           else
                                             RestBusinessHour.new(date: hotel.rest_rates.where(day_id: Day.select_a_day_of_the_week.where(hotel_id: hotel.id).ids)).extract_the_rest_rate
                                           end)
      end
      rest_rate_list
    end

    def sorted_low_rest
      hotel = []
      select_rest_rates.preload(:day, :hotel, hotel: :hotel_images).sort_by(&:rate).each do |sorted_rest|
        hotel << sorted_rest.hotel
      end
      hotel
    end

    def search_params
      params.permit(:keyword, :city_and_street_address, :sort)
    end
end

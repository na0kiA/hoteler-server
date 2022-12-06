# frozen_string_literal: true

class V1::SearchController < ApplicationController
  def index
    @accepted_hotel = Hotel.accepted
    @hotel = Hotel.none
    p select_a_day

    if search_params[:keyword].present?
      search_each_params_of_keyword(split_params: split_keyword)
      if @hotel.blank?
        render json: render_not_match_params(search_params[:keyword])
      else
        render json: @hotel, each_serializer: HotelIndexSerializer
      end

    elsif search_params[:city_and_street_address].present?
      search_each_params_of_city_or_street_address(split_params: split_city_and_street_address)
      if @hotel.blank?
        render json: render_not_match_params(search_params[:city_and_street_address])
      else
        render json: @hotel, each_serializer: HotelIndexSerializer
      end

    # elsif search_params[:lower_rest].present?

    else
      redirect_to v1_hotels_path
    end
  end

  private

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

    def select_a_day
      result = []
      @accepted_hotel.each do |hotel|
        if SpecialPeriod.check_that_today_is_a_special_period?(hotel: hotel)
          result << RestBusinessHour.new(date: hotel.rest_rates.where(day_id: Day.special_day.where(hotel_id: hotel.id).ids)).extract_the_rest_rate.first
        else
          result << RestBusinessHour.new(date: hotel.rest_rates.where(day_id: Day.select_a_day_of_the_week.where(hotel_id: hotel.id).ids)).extract_the_rest_rate.first
        end
      end
      result.compact
    end

    def search_params
      params.permit(:keyword, :city_and_street_address, :lower_price)
    end
end

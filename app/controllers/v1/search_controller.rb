# frozen_string_literal: true

class V1::SearchController < ApplicationController
  def index
    @accepted_hotel = Hotel.accepted
    @hotel = Hotel.none

    if search_params[:keyword].present?
      search_each_params_of_keyword(split_params: split_keyword)

      if sort_by_low_rest?
        cheap_rest_hotels = HotelSort.new(hotels: @hotel).sort_by_low_rest
        render json: cheap_rest_hotels, each_serializer: HotelIndexSerializer
      elsif sort_by_high_rest?
        expensive_rest_hotels = HotelSort.new(hotels: @hotel).sort_by_high_rest
        render json: expensive_rest_hotels, each_serializer: HotelIndexSerializer
      elsif @hotel.blank?
        render json: render_not_match_params(search_params[:keyword])
      else
        render json: @hotel, each_serializer: HotelIndexSerializer
      end
    end

    if search_params[:city_and_street_address].present?
      search_each_params_of_city_or_street_address(split_params: split_city_and_street_address)

      if sort_by_low_rest?
        cheap_rest_hotels = HotelSort.new(hotels: @hotel).sort_by_low_rest
        render json: cheap_rest_hotels, each_serializer: HotelIndexSerializer
      elsif sort_by_high_rest?
        expensive_rest_hotels = HotelSort.new(hotels: @hotel).sort_by_high_rest
        render json: expensive_rest_hotels, each_serializer: HotelIndexSerializer
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

    def sort_by_high_rest?
      search_params[:sort] == "high_rest"
    end

    def sort_by_low_stay?
      search_params[:sort] == "low_stay"
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

    def search_params
      params.permit(:keyword, :city_and_street_address, :sort)
    end
end

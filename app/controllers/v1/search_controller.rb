# frozen_string_literal: true

class V1::SearchController < ApplicationController
  def index
    @accepted_hotel = Hotel.accepted
    @hotel = Hotel.none

    if search_params[:keyword].present?
      search_each_params_of_keyword(split_params: split_keyword)
      hotels = HotelSort.new(hotels: @hotel)
      if sort_by_low_rest?
        render json: hotels.sort_by_low_rest, each_serializer: HotelIndexSerializer
      elsif sort_by_high_rest?
        render json: hotels.sort_by_high_rest, each_serializer: HotelIndexSerializer
      elsif sort_by_low_stay?
        render json: hotels.sort_by_low_stay, each_serializer: HotelIndexSerializer
      elsif sort_by_high_stay?
        render json: hotels.sort_by_high_stay, each_serializer: HotelIndexSerializer
      elsif @hotel.blank?
        render json: render_not_match_params(search_params[:keyword])
      else
        render json: @hotel, each_serializer: HotelIndexSerializer
      end
    end

    if search_params.blank? || (search_params[:keyword].blank? && search_params[:sort].blank?)
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

    def sort_by_high_stay?
      search_params[:sort] == "high_stay"
    end

    def search_each_params_of_keyword(split_params:)
      split_params.each do |keyword|
        @hotel = @hotel.or(search_keyword(keyword:))
      end
    end

    def search_keyword(keyword:)
      @accepted_hotel.search_multiple(keyword)
    end

    def render_not_match_params(params)
      "#{params}の検索結果が見つかりませんでした"
    end

    def split_keyword
      search_params[:keyword].split(/[[:blank:]]+/).select(&:present?)
    end

    def search_params
      params.permit(:keyword, :sort)
    end
end

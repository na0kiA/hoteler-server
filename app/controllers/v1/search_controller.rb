# frozen_string_literal: true

class V1::SearchController < ApplicationController
  def index
    if search_params[:keyword].present?
      sort_or_not
    else
      redirect_to v1_hotels_path
    end
  end

  private

    def sort_or_not
      searched_hotel_list = search_each_params_of_keyword(box_for_searched_list: Hotel.none, split_params: split_keyword, accepted_hotel: Hotel.accepted)
      hotels = HotelSort.new(hotels: searched_hotel_list)

      should_sort(hotels:)
      no_sort(searched_hotel_list:)
    end

    def should_sort(hotels:)
      return render json: hotels.sort_by_low_rest, each_serializer: HotelIndexSerializer if sort_by_low_rest?
      return render json: hotels.sort_by_low_stay, each_serializer: HotelIndexSerializer if sort_by_low_stay?
      return render json: hotels.sort_by_high_rest, each_serializer: HotelIndexSerializer if sort_by_high_rest?
      return render json: hotels.sort_by_high_stay, each_serializer: HotelIndexSerializer if sort_by_high_stay?
    end

    def no_sort(searched_hotel_list:)
      return render json: render_not_match_params(search_params[:keyword]), each_serializer: HotelIndexSerializer if searched_hotel_list.blank?
      return render json: searched_hotel_list, each_serializer: HotelIndexSerializer if search_params[:sort].blank?
    end

    def search_each_params_of_keyword(box_for_searched_list:, split_params:, accepted_hotel:)
      split_params.each do |keyword|
        box_for_searched_list = box_for_searched_list.or(search_keyword(keyword:, accepted_hotel:))
      end
      box_for_searched_list
    end

    def search_keyword(keyword:, accepted_hotel:)
      accepted_hotel.search_multiple(keyword)
    end

    def render_not_match_params(params)
      "#{params}の検索結果が見つかりませんでした"
    end

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

    def split_keyword
      search_params[:keyword].split(/[[:blank:]]+/).select(&:present?)
    end

    def search_params
      params.permit(:keyword, :sort)
    end
end

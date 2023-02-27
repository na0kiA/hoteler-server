# frozen_string_literal: true

class V1::SearchController < ApplicationController
  def index
    empty_hotel_box_for_searched_list = Hotel.none
    accepted_hotel = Hotel.accepted

    if search_params[:keyword].present?
      binding.break
      searched_by_keyword_hotel_list = search_each_params_of_keyword(box_for_searched_list: empty_hotel_box_for_searched_list, accepted_hotel:).eager_load(:hotel_facility, :stay_rates, :rest_rates)

      filterd_hotel_list = filterd_hotels(searched_by_keyword_hotel_list:)

      sorting_not_needed(searched_by_keyword_hotel_list: filterd_hotel_list)

      sort_hotel_list(searched_by_keyword_hotel_list: filterd_hotel_list)
    else
      record_not_found
    end
  end

  private

    def filterd_hotels(searched_by_keyword_hotel_list:)
      return searched_by_keyword_hotel_list if search_params[:hotel_facilities].blank?

      filterd_hotel_list = HotelFilter.new(hotel_list: searched_by_keyword_hotel_list, filter_conditions: search_params[:hotel_facilities]).filter
      filterd_hotel_list_with_relation = Hotel.where(id: filterd_hotel_list.map(&:id))

      filterd_hotel_list_with_relation.presence || render_not_match_filters
    end

    def sort_hotel_list(searched_by_keyword_hotel_list:)
      sort_by_price(hotels: HotelSort.new(hotels: searched_by_keyword_hotel_list))
      sort_by_reviews_count(hotels: searched_by_keyword_hotel_list)
      sort_by_favorites_count(hotels: searched_by_keyword_hotel_list)
    end

    def sort_by_price(hotels:)
      return render json: hotels.sort_by_low_rest, each_serializer: HotelIndexSerializer, services: hotels.select_services(sorted_hotels: hotels.sort_by_low_rest) if sort_by_low_rest?

      return render json: hotels.sort_by_low_stay, each_serializer: HotelIndexSerializer, services: hotels.select_services(sorted_hotels: hotels.sort_by_low_stay) if sort_by_low_stay?

      return render json: hotels.sort_by_high_rest, each_serializer: HotelIndexSerializer, services: hotels.select_services(sorted_hotels: hotels.sort_by_high_rest)  if sort_by_high_rest?

      return render json: hotels.sort_by_high_stay, each_serializer: HotelIndexSerializer, services: hotels.select_services(sorted_hotels: hotels.sort_by_high_stay)  if sort_by_high_stay?
    end

    def sort_by_reviews_count(hotels:)
      return render json: hotels.eager_load(:hotel_images).sort_by(&:reviews_count).reverse, each_serializer: HotelIndexSerializer if sort_by_reviews_count?
    end

    def sort_by_favorites_count(hotels:)
      return render json: hotels.eager_load(:hotel_images).sort_by(&:favorites_count).reverse, each_serializer: HotelIndexSerializer if sort_by_favorites_count?
    end

    def sorting_not_needed(searched_by_keyword_hotel_list:)
      return render json: render_not_match_params(search_params[:keyword]), each_serializer: HotelIndexSerializer if searched_by_keyword_hotel_list.blank?
      return render json: searched_by_keyword_hotel_list, each_serializer: HotelIndexSerializer if search_params[:sort].blank?
      return search_not_found if not_match_any_sort_params?
    end

    def not_match_any_sort_params?
      !sort_by_low_rest? && !sort_by_high_rest? && !sort_by_low_stay? && !sort_by_high_stay? && !sort_by_reviews_count? && !sort_by_favorites_count?
    end

    def search_each_params_of_keyword(box_for_searched_list:, accepted_hotel:)
      split_keyword.each do |keyword|
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

    def render_not_match_filters
      "絞り込み条件で一致するホテルがありませんでした。違う条件と検索キーワードでお試しください。"
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

    def sort_by_reviews_count?
      search_params[:sort] == "reviews_count"
    end

    def sort_by_favorites_count?
      search_params[:sort] == "favorites_count"
    end

    def split_keyword
      search_params[:keyword].split(/[[:blank:]]+/).select(&:present?)
    end

    def search_params
      params.permit(:keyword, :sort, hotel_facilities: [])
    end
end

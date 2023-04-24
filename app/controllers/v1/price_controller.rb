# frozen_string_literal: true

class V1::PriceController < ApplicationController
  def index
    if params[:service_type] == "休憩"
      search_rest_rate = RestRate.where(rate: price_params[:min_price]..price_params[:max_price])
      hotels = Hotel.rest_rates.where(id: search_rest_rate.pluck(:hotel_id))
    else
      search_stay_rate = StayRate.where(rate: price_params[:min_price]..price_params[:max_price])
      hotels = Hotel.rest_rates.where(id: search_stay_rate.pluck(:hotel_id))
    end
    render json: hotels, each_serializer: HotelIndexSerializer, services: ExtractTodayService.new(hotels:).extract_today_services
  end

  private

    def price_params
      params.permit(:min_price, :max_price, :service_type)
    end
end

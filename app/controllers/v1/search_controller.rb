class V1::SearchController < ApplicationController

  def index
    @accepted_hotel = Hotel.accepted

    if search_params[:keyword].present?
      split_keyword.each do |keyword|
        @hotel = []
        @hotel << @accepted_hotel.search_multiple(keyword)
      end
      render json: @hotel.first, each_serializer: HotelIndexSerializer
    end

    if search_params[:city].present?
      split_keyword.each do |keyword|
        @hotel = []
        @hotel << @accepted_hotel.search_multiple(keyword)
      end
      render json: @hotel.first, each_serializer: HotelIndexSerializer
    end

    if search_params.blank?
      redirect_to v1_hotels_path
    end

  end

  private

  def split_keyword
    search_params[:keyword].split(/[[:blank:]]+/)
  end

  def search_params
    params.permit(:name, :prefecture, :city, :street_address, :postal_code, :company, :keyword)
  end
end

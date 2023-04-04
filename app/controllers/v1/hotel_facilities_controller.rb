# frozen_string_literal: true

class V1::HotelFacilitiesController < ApplicationController
  before_action :authenticate_v1_user!

  def update
    if set_hotel.present? && authenticated?
      set_facility.update(hotel_facility_params)
      render json: set_hotel, status: :ok, serializer: HotelShowSerializer
    else
      render json: set_hotel.errors, status: :bad_request
    end
  end

  private

    def authenticated?
      set_hotel.user == current_v1_user
    end

    def set_hotel
      current_v1_user.hotels.find(params[:hotel_id])
    end

    def set_facility
      set_hotel.hotel_facility
    end

    def hotel_facility_params
      params.require(:hotel_facilities).permit(:wifi_enabled, :parking_enabled, :triple_rooms_enabled, :secret_payment_enabled, :credit_card_enabled, :phone_reservation_enabled,
                                               :net_reservation_enabled, :cooking_enabled, :breakfast_enabled, :coupon_enabled).merge(hotel_id: set_hotel.id)
    end
end

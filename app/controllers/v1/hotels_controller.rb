module V1
  class HotelsController < ApplicationController
    before_action :authenticate_v1_user!, except: %i[index show]
    before_action :set_hotel, only: %i[show update destroy]

    def index
      render json: Hotel.accepted
    end

    def show
      accepted_hotel = Hotel.accepted.find_by(id: @hotel)
      if accepted_hotel.present?
        render json: accepted_hotel
      else
        record_not_found
      end
    end

    def create
      hotel_form = HotelForm.new(hotel_params)
      if hotel_form.save
        render json: hotel_form, status: :ok
      else
        render json: hotel_form.errors, status: :bad_request
      end
    end

    def update
      hotel_form = HotelForm.new(hotel_params)
      if hotel_form.valid? && authenticated?
        HotelProfile.new(params: hotel_form.to_deep_symbol, set_hotel: @hotel).update
        render json: hotel_form, status: :ok
      else
        render json: hotel_form.errors, status: :bad_request
      end
    end

    def destroy
      if authenticated?
        @hotel.destroy
        render json: @hotel, status: :ok
      else
        render json: @hotel.errors, status: :bad_request
      end
    end

    private

    def authenticated?
      @hotel.present? && @hotel.user.id == current_v1_user.id
    end

    def hotel_params
      params.require(:hotel).permit(:name, :content, :rest, key: []).merge(user_id: current_v1_user.id)
    end

    def set_hotel
      @hotel = Hotel.find(params[:id])
    end
  end
end

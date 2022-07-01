module V1
  class HotelsController < ApplicationController
    before_action :authenticate_v1_user!, except: %i[index show]
    before_action :hotel_id, only: %i[show destroy]

    def index
      render json: Hotel.accepted
    end

    def show
      accepted_hotel = Hotel.accepted.find(id: @hotel)
      if accepted_hotel.present?
        render json: accepted_hotel
      else
        record_not_found
      end
    end

    def create
      hotel = Hotel.new(hotel_params)
      if hotel.save && hotel.present?
        render json: hotel, status: :ok
      else
        render json: hotel.errors, status: :bad_request
      end
    end

    def destroy
      # hotel = Hotel.find(hotel_id)
      if @hotel.present? && @hotel.user.id == current_v1_user.id
        @hotel.destroy
        render json: @hotel, status: :ok
      else
        render json: @hotel.errors, status: :bad_request
      end
    end

    private

    def hotel_params
      params.require(:hotel).permit(:name, :content).merge(user_id: current_v1_user.id)
    end

    def hotel_id
      @hotel = Hotel.find(params[:id])
    end
  end
end

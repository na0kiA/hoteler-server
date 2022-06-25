module V1
  class HotelsController < ApplicationController
    before_action :authenticate_v1_user!, except: %i[index show]

    # TODO: acceptedがtrueのホテルのみ表示させる
    def index
      hotel = Hotel.where(accepted: params[:accepted])
      accepted_hotel = Hotel.where(accepted: true)
      if hotel == true
        render json: accepted_hotel
      else
        render json: hotel.errors, status: :bad_request
      end
    end

    def show
      render json: Hotel.find(params[:id])
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
      hotel = Hotel.find_by(id: params[:id])
      if hotel.present? && hotel.user.id == current_v1_user.id
        hotel.destroy
        render json: hotel, status: :ok
      else
        render json: hotel.errors, status: :bad_request
      end
    end

    private

    def hotel_params
      params.permit(:name, :content).merge(user_id: current_v1_user.id)
    end
  end
end

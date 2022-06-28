module V1
  class HotelsController < ApplicationController
    before_action :authenticate_v1_user!, except: %i[index show]

    def index
      # accepted_hotels = Hotel.accepted
      render json: Hotel.accepted
    end

    def show
      accepted_hotel = Hotel.accepted.find_by(id: params[:id])
      if accepted_hotel.present?
        render json: accepted_hotel
      else
        # TODO: 存在しないホテルがURLに入った場合エラーメッセージ
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

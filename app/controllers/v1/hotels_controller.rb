# frozen_string_literal: true

module V1
  class HotelsController < ApplicationController
    before_action :authenticate_v1_user!, except: %i[index show]
    before_action :set_hotel, only: %i[show update destroy]

    def index
      hotel = Hotel.accepted
      render json: hotel, serializer: HotelSerializer
    end

    def show
      hotel = Hotel.accepted.find_by(id: @hotel.id)
      if hotel.present?
        render json: hotel, serializer: HotelSerializer
      else
        record_not_found
      end
    end

    def create
      hotel = Hotel.new(hotel_params)
      if hotel.save
        render json: hotel, status: :ok
      else
        render json: hotel.errors, status: :bad_request
      end
    end

    def update
      if @hotel.present? && authenticated?
        @hotel.update!(hotel_params)
        render json: @hotel, status: :ok
      else
        render json: @hotel.errors, status: :bad_request
      end
    end

    def destroy
      if @hotel.present? && authenticated?
        @hotel.destroy
        render json: @hotel, status: :ok
      else
        render json: @hotel.errors, status: :bad_request
      end
    end

    private

      def authenticated?
        @hotel.user.id == current_v1_user.id
      end

      def hotel_params
        params.require(:hotel).permit(:name, :content).merge(user_id: current_v1_user.id)
      end

      def set_hotel
        @hotel = Hotel.find(params[:id])
      end
  end
end

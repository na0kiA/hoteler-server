module V1
  class HotelsController < ApplicationController
    before_action :authenticate_v1_user!, except: %i[index show]

    def index
      render json: Hotel.all
    end

    def show
      render json: Hotel.find(params[:id])
    end

    def create
      hotel = Hotel.new(hotel_params)
      if hotel.save
        render json: hotel, status: :ok
      else
        render json: hotel.errors
      end
    end

    private

    def hotel_params
      params.permit(:name, :content).merge(user_id: current_v1_user.id)
    end
  end
end

# frozen_string_literal: true

class V1::DaysController < ApplicationController
  before_action :authenticate_v1_user!

  def create
    day = Day.new(day_params)
    if day.save
      render json: day, status: :ok
    else
      render json: day.errors, status: :bad_request
    end
  end

  private

    def day_params
      params.permit(:day).merge(hotel_id: set_hotel.id)
    end

    def set_hotel
      @hotel = Hotel.find(params[:hotel_id])
    end
end

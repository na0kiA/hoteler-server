# frozen_string_literal: true

class V1::DaysController < ApplicationController
  before_action :set_hotel, only: [:index]

  def index
    if @hotel.present?
      render json: @hotel.days
    else
      record_not_found
    end
  end

  private

    def set_hotel
      @hotel = Hotel.find(params[:hotel_id])
    end
end

# frozen_string_literal: true

class V1::RoomStatusController < ApplicationController
  def index
    hotel = Hotel.where(full: false)
    render json: hotel, each_serializer: HotelIndexSerializer
  end
end
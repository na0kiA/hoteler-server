# frozen_string_literal: true

class V1::HotelImagesController < ApplicationController
  before_action :authenticate_v1_user!, only: %i[create]
  before_action :set_image, only: %i[show]
  before_action :set_hotel, only: %i[index show]

  def index
    if (@hotel.accepted? && hotel_image_present?) || (hotel_image_present? && authenticated?)
      render json: @hotel.hotel_images,
             each_serializer: HotelImageSerializer
    else
      record_not_found
    end
  end

  def show
    if (@hotel.accepted? && @image.present?) || (@image.present? && authenticated?)
      render json: @image,
             Serializer: HotelImageSerializer
    else
      record_not_found
    end
  end

  def create
    image = HotelImage.new(image_params)
    if image.save
      render json: image, status: :ok
    else
      render json: image.errors, status: :bad_request
    end
  end

  private

    def authenticated?
      return if current_v1_user.blank?

      @hotel.user_id == current_v1_user.id
    end

    def image_params
      params.require(:hotel_image).permit(key: []).merge(hotel_id: set_hotel.id)
    end

    def hotel_image_present?
      set_hotel.hotel_images.present?
    end

    def set_image
      @image = HotelImage.find(params[:id])
    end

    def set_hotel
      @hotel = Hotel.find(params[:hotel_id])
    end
end

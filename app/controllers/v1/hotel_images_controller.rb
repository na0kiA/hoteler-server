# frozen_string_literal: true

class V1::HotelImagesController < ApplicationController
  before_action :authenticate_v1_user!
  before_action :set_image, only: %i[show update destroy]
  # before_action :set_hotel, only: %i[show update destroy]

# TODO: 承認済みのホテルの画像を表示する
  def index
    render json: Hotel.hotel_images
  end

  def show
    if @image.present?
      render json: @image
    else
      record_not_found
    end
  end

  def create
    image = HotelImage.new(image_params)
    if image.save!
      render json: image, status: :ok
    else
      render json: image.errors, status: :bad_request
    end
  end

  def update
    if @image.present? && authenticated?
      @image.update!(image_params)
      render json: image, status: :ok
    else
      render json: image.errors, status: :bad_request
    end
  end

  def destroy
    if @image.present? && authenticated?
      @image.destroy
      render json: @image, status: :ok
    else
      render json: @image.errors, status: :bad_request
    end
  end

  private

    def authenticated?
      @image.user.id == current_v1_user.id
    end

    def image_params
      params.require(:hotel_image).permit(key: []).merge(hotel_id: set_hotel.id)
    end

    def set_image
      @image = HotelImage.find(params[:id])
    end

    def set_hotel
      @hotel = Hotel.find(params[:hotel_id])
    end
end

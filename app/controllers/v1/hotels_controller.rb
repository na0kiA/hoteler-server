module V1
  class HotelsController < ApplicationController
    before_action :authenticate_v1_user!, except: %i[index show]
    before_action :hotel_id, only: %i[show destroy update]

    def index
      render json: Hotel.accepted
    end

    def show
      accepted_hotel = Hotel.accepted.find_by(id: @hotel)
      if accepted_hotel.present?
        render json: accepted_hotel
      else
        record_not_found
      end
    end

    def create
      hotel_form = HotelForm.new(hotel_params)
      if hotel_form && Hotel.create!(hotel_form.params)
        render json: hotel_form, status: :ok
      else
        render json: hotel_form.errors, status: :bad_request
      end
    end

    # def create
    #   hotel = Hotel.new(hotel_params)
    #   if hotel.save && hotel.present?
    #     render json: hotel, status: :ok
    #   else
    #     render json: hotel.errors, status: :bad_request
    #   end
    # end

    def update
      if @hotel.present? && @hotel.user.id == current_v1_user.id
        @hotel.update(hotel_params)
        render json: @hotel, status: :ok
      else
        render json: @hotel.errors, status: :bad_request
      end
    end

    def destroy
      if @hotel.present? && @hotel.user.id == current_v1_user.id
        @hotel.destroy
        render json: @hotel, status: :ok
      else
        render json: @hotel.errors, status: :bad_request
      end
    end

    private

    def hotel_params
      params.require(:hotel).permit(:name, :content, images: [:hotel_s3_key]).merge(user_id: current_v1_user.id)
    end

    def hotel_id
      @hotel = Hotel.find(params[:id])
    end
  end
end

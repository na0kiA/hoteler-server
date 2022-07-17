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
      hotel = Hotel.new(hotel_params)
      if hotel.save && hotel.present?
        render json: hotel, status: :ok
      else
        render json: hotel.errors, status: :bad_request
      end
    end

    def update
      if @hotel.present? && @hotel.user.id == current_v1_user.id
        @hotel.update(hotel_params)
        render json: @hotel, status: :ok
      else
        render json: @hotel.errors, status: :bad_request
      end
    end

    def destroy
      # hotel = Hotel.find(hotel_id)
      if @hotel.present? && @hotel.user.id == current_v1_user.id
        @hotel.destroy
        render json: @hotel, status: :ok
      else
        render json: @hotel.errors, status: :bad_request
      end
    end

    def signed_url
      resource = S3_BUCKET.presigned_post(
        key: "uploads/hotel/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read', content_length_range: 1..(10.megabytes)
      )
      render json: { url: resource.url, fields: resource.fields }
    end

    def save_key
      
    end

    def file_url
      Aws::S3::Object.new(ENV.fetch('S3_BUCKET', nil), key).public_url
    end

    private

    def hotel_params
      params.require(:hotel).permit(:name, :content).merge(user_id: current_v1_user.id)
    end

    def hotel_id
      @hotel = Hotel.find(params[:id])
    end

    def hotel_key
      @hotel = Hotel.find(params[:image_id])
    end
  end
end

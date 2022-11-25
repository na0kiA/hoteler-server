# frozen_string_literal: true

module V1
  class HotelsController < ApplicationController
    before_action :authenticate_v1_user!, except: %i[index show]
    before_action :set_hotel, only: %i[show update destroy]

    def index
      hotel = Hotel.accepted
      render json: hotel, each_serializer: HotelIndexSerializer
    end

    def show
      accepted_hotel = Hotel.accepted.find_by(id: @hotel.id)
      if accepted_hotel.present?
        render json: accepted_hotel, serializer: HotelShowSerializer
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
        if update_only_fulled_room?(@hotel)
          @hotel.update!(hotel_params)
          render json: @hotel, serializer: HotelShowSerializer, status: :ok
        elsif message_blank?
          render_bad_request_with_update_message_invalid
        else
          @hotel.update!(hotel_params) && send_notification(@hotel)
          render json: @hotel, serializer: HotelShowSerializer, status: :ok
        end
      else
        render json: @hotel.errors, status: :bad_request
      end
    end

    def destroy
      if @hotel.present? && authenticated?
        @hotel.destroy
        render json: {}, status: :ok
      else
        render json: @hotel.errors, status: :bad_request
      end
    end

    private

      def authenticated?
        @hotel.user.id == current_v1_user.id
      end

      def update_only_fulled_room?(hotel)
        hotel_params[:full] != hotel.full && hotel_params.values_at(:name, :content) == [hotel.name, set_hotel.content]
      end

      def send_notification(hotel)

        hotel.send_notification_when_update(hotel_manager: current_v1_user, user_id_list: hotel.favorite_users.pluck(:id), hotel_id: hotel.id, message: notification_params[:message] )
      end

      def render_bad_request_with_update_message_invalid
        render_json_bad_request_with_custom_errors(title: "ホテルを編集できませんでした", body: "更新メッセージを必ず入力してください") 
      end

      def message_blank?
        notification_params[:message].blank?
      end

      def hotel_params
        params.require(:hotel).permit(:name, :content, :full).merge(user_id: current_v1_user.id)
      end

      def notification_params
        params.require(:notification).permit(:message)
      end

      def set_hotel
        @hotel = Hotel.find(params[:id])
      end
  end
end

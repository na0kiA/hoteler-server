# frozen_string_literal: true

module V1
  class HotelsController < ApplicationController
    before_action :authenticate_v1_user!, except: %i[index show]
    before_action :set_hotel, only: %i[show update destroy]

    def index
      # Hotel.return_day_of_week
      # render json: RestRate.new.now_rest_rate
      render json: Hotel.accepted
    end

    def show
      accepted_hotel = Hotel.accepted.find_by(id: @hotel.id)
      if accepted_hotel.present?
        render json: accepted_hotel
      else
        record_not_found
      end
    end

    def create
      hotel_form = HotelForm.new(hotel_params)
      if hotel_form.save
        render json: hotel_form, status: :ok
      else
        render json: hotel_form.errors, status: :bad_request
      end
    end

    def update
      hotel_form = HotelForm.new(hotel_params)
      if hotel_form.valid? && authenticated?
        HotelProfile.new(params: hotel_form.to_deep_symbol, set_hotel: @hotel).update
        render json: hotel_form, status: :ok
      else
        render json: hotel_form.errors, status: :bad_request
      end
    end

    def destroy
      if authenticated?
        @hotel.destroy
        render json: @hotel, status: :ok
      else
        render json: @hotel.errors, status: :bad_request
      end
    end

    private

      def authenticated?
        @hotel.present? && @hotel.user.id == current_v1_user.id
      end

      def hotel_params
        params.require(:hotel).permit(:name, :content, key: []).merge(user_id: current_v1_user.id)
        top_page_params
      end

      def top_page_params
        friday_rate_params
        monday_through_thursday_rate_params
        saturday_rate_params
        sunday_rate_params
        holiday_rate_params
        special_period_rate_params
      end

      def friday_rate_params
        params.require(:hotel).permit(:day, friday: {rest_rates: %i[plan rate first_time last_time], stay_rates: %i[plan rate first_time last_time]})
      end

      # def friday_rate_params
      #   params.require(:hotel).permit(friday: { rest_rates: %i[plan rate first_time last_time], stay_rates: %i[plan rate first_time last_time]})
      # end

      def monday_through_thursday_rate_params
        params.require(:hotel).permit(monday_through_thursday: { rest_rates: %i[plan rate first_time last_time], stay_rates: %i[plan rate first_time last_time]})
      end

      def saturday_rate_params
        params.require(:hotel).permit(saturday: { rest_rates: %i[plan rate first_time last_time], stay_rates: %i[plan rate first_time last_time]})
      end

      def sunday_rate_params
        params.require(:hotel).permit(sunday: { rest_rates: %i[plan rate first_time last_time], stay_rates: %i[plan rate first_time last_time]})
      end

      def holiday_rate_params
        params.require(:hotel).permit(holiday: { rest_rates: %i[plan rate first_time last_time], stay_rates: %i[plan rate first_time last_time]})
      end

      def special_period_rate_params
        params.require(:hotel).permit(special_rate: { rest_rates: %i[plan rate first_time last_time], stay_rates: %i[plan rate first_time last_time], special_periods: %i[period start_date end_date]})
      end

      def set_hotel
        @hotel = Hotel.find(params[:id])
      end
  end
end

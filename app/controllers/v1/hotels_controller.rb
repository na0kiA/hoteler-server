# frozen_string_literal: true

module V1
  class HotelsController < ApplicationController
    before_action :authenticate_v1_user!, except: %i[index show]
    before_action :set_hotel, only: %i[show update destroy]

    def index
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
        params.require(:hotel).permit(:name, :content, daily_rates: daily_rate_params, special_periods: special_period_params, key: []).merge(user_id: current_v1_user.id)
      end

      def special_period_params
        { obon: %i[period start_date end_date], golden_week: %i[period start_date end_date], the_new_years_holiday: %i[period start_date end_date] }
      end

      def fee_params
        { rest_rates: %i[plan rate first_time last_time] }
      end

      def daily_rate_params(fee = fee_params)
        { monday_through_thursday: fee, friday: fee, saturday: fee, sunday: fee, holiday: fee, day_before_a_holiday: fee, special_days: fee }
      end

      def set_hotel
        @hotel = Hotel.find(params[:id])
      end
  end
end

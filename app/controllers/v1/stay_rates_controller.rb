# frozen_string_literal: true

class V1::StayRatesController < ApplicationController
  before_action :authenticate_v1_user!
  before_action :set_stay_rate, only: %i[update destroy]

  def create
    stay_rate = StayRate.new(stay_rate_params)
    if stay_rate.save
      render json: stay_rate, status: :ok
    else
      render json: stay_rate.errors, status: :bad_request
    end
  end

  def update
    if authenticated? && @stay_rate.present?
      if @stay_rate.update(stay_rate_params)
        render json: @stay_rate, status: :ok
      else
        render json: @stay_rate.errors, status: :bad_request
      end
    else
      render json: {}, status: :bad_request
    end
  end

  def destroy
    if authenticated? && @stay_rate.present?
      @stay_rate.destroy!
      render json: @stay_rate, status: :ok
    else
      render json: @stay_rate.errors, status: :bad_request
    end
  end

  private

    def stay_rate_params
      params.require(:stay_rate).permit(:plan, :rate, :start_time, :end_time).merge(day_id: set_day.id)
    end

    def set_stay_rate
      @stay_rate = StayRate.find(params[:id])
    end

    def set_day
      @day = Day.find(params[:day_id])
    end

    def authenticated?
      set_stay_rate.day.hotel.user_id == current_v1_user.id
    end
end

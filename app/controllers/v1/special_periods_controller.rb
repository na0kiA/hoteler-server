# frozen_string_literal: true

class V1::SpecialPeriodsController < ApplicationController
  before_action :authenticate_v1_user!
  before_action :set_special_period, only: %i[update destroy]

  def index
    special_period = SpecialPeriod.where(day_id: params[:day_id])
    if special_period.present?
      render json: special_period, each_serializer: SpecialPeriodSerializer
    else
      render json: {}, status: :no_content
    end
  end


  def create
    special_period = SpecialPeriod.new(special_period_params)
    if special_period.save
      render json: special_period, status: :ok
    else
      render json: special_period.errors, status: :bad_request
    end
  end

  def update
    if authenticated? && @special_period.present?
      if @special_period.update(special_period_params)
        render json: @special_period, status: :ok
      else
        render json: @special_period.errors, status: :bad_request
      end
    else
      render json: {}, status: :bad_request
    end
  end

  def destroy
    if authenticated? && @special_period.present?
      @special_period.destroy!
      render json: @special_period, status: :ok
    else
      render json: @special_period.errors, status: :bad_request
    end
  end

  private

    def special_period_params
      params.require(:special_period).permit(:period, :start_date, :end_date).merge(day_id: set_day.id)
    end

    def set_special_period
      @special_period = SpecialPeriod.find(params[:id])
    end

    def set_day
      @day = Day.find(params[:day_id])
    end

    def authenticated?
      @special_period.day.hotel.user_id == current_v1_user.id
    end
end

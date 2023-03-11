# frozen_string_literal: true

class V1::RestRatesController < ApplicationController
  before_action :authenticate_v1_user!
  before_action :set_rest_rate, only: %i[update destroy]

  def index
    rest_rates = RestRate.where(day_id: params[:day_id])
    if rest_rates.present?
      render json: rest_rates.eager_load(:day), each_serializer: RestRateSerializer
    else
      render json: {}, status: :no_content
    end
  end

  def create
    rest_rate = RestRate.new(rest_rate_params)
    if rest_rate.save
      render json: rest_rate, status: :ok
    else
      render json: rest_rate.errors, status: :bad_request
    end
  end

  def update
    if authenticated? && @rest_rate.present?
      if @rest_rate.update(rest_rate_params)
        render json: @rest_rate, status: :ok
      else
        render json: @rest_rate.errors, status: :bad_request
      end
    else
      render json: {}, status: :bad_request
    end
  end

  def destroy
    if authenticated? && @rest_rate.present?
      @rest_rate.destroy!
      render json: @rest_rate, status: :ok
    else
      render json: @rest_rate.errors, status: :bad_request
    end
  end

  private

    def rest_rate_params
      params.require(:rest_rate).permit(:plan, :rate, :start_time, :end_time).merge(day_id: set_day.id)
    end

    def set_rest_rate
      @rest_rate = RestRate.find(params[:id])
    end

    def set_day
      @day = Day.find(params[:day_id])
    end

    def authenticated?
      @rest_rate.day.hotel.user_id == current_v1_user.id
    end
end

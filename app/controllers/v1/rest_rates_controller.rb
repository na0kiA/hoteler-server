# frozen_string_literal: true

class V1::RestRatesController < ApplicationController
  before_action :authenticate_v1_user!
  before_action :set_rest_rate, only: %i[update destroy]

  def create
    rest_rate = RestRate.new(rest_rate_params)
    if rest_rate.save!
      render json: rest_rate, status: :ok
    else
      render json: rest_rate.errors, status: :bad_request
    end
  end

  def update
    rest_rate = RestRate.new(rest_rate_params)
    if authenticated? && @rest_rate.present?
      @rest_rate.update!(rest_rate_params)
      render json: rest_rate, status: :ok
    else
      render json: rest_rate.error, status: :bad_request
    end
  end

  def destroy
    if authenticated? && @rest_rate.present?
      @rest_rate.destroy!
      render json: @rest_rate
    else
      render json: @hotel.errors, status: :bad_request
    end
  end

  private

    def rest_rate_params
      params.require(:rest_rate).permit(:plan, :rate, :first_time, :last_rate)
    end

    def set_rest_rate
      @rest_rate = RestRate.find(params[:id])
    end

    def authenticated?
      @rest_rate.day.hotel.user_id == current_v1_user.id
    end
end

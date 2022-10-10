# frozen_string_literal: true

class HotelProfile
  attr_reader :params, :set_hotel, :key, :day, :friday_rates, :today_rest_rate, :plan, :rate, :first_time, :last_time

  def initialize(params:, set_hotel:)
    @params = params
    @set_hotel = set_hotel
    @key = JSON.parse(params[:key])
    @friday_rates = params.fetch(:friday_rates)
    @day = friday_rates.fetch(:day)
    @today_rest_rate = friday_rates.fetch(:rest_rates)
    @plan = today_rest_rate.fetch(:plan)
    @rate = today_rest_rate.fetch(:rate)
    @first_time = today_rest_rate.fetch(:first_time)
    @last_time = today_rest_rate.fetch(:last_time)
    freeze
  end

  def update
    ActiveRecord::Base.transaction do
      update_hotel
      find_or_create_key
      remove_unnecessary_key
      update_day
      update_friday_rest_rates
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

    def update_hotel
      Hotel.update!(set_hotel.id, name: params[:name], content: params[:content])
    end

    def difference_key_array
      set_hotel.hotel_images.pluck(:key).difference(key)
    end

    def find_or_create_key
      key.each do |val|
        set_hotel.hotel_images.find_or_create_by!(key: val)
      end
    end

    def remove_unnecessary_key
      set_hotel.hotel_images.where(key: difference_key_array).delete_all
    end

    def update_day
      Day.update!(set_day_ids, day:, hotel_id: set_hotel.id)
    end

  # TODO: 複数個のdayを取得する必要がある
    def set_day_ids
      set_hotel.days.pick(:id)
      # set_hotel.days.all.pluck(:id).slice(0)
    end

  # TODO: FIX_ME: updated_atが更新されてしまう
    def update_friday_rest_rates
      RestRate.update!(pick_rest_rate.id, plan:, rate:, first_time:, last_time:, day_id: set_day_ids)
    end

    def pick_rest_rate
      # update_day.rest_rates.pick(:id)
      RestRate.find_by(day_id: set_day_ids)
    end
end

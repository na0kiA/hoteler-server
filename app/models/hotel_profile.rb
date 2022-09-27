class HotelProfile
  attr_reader :params, :set_hotel, :key, :day, :daily_rates, :today_rest_rate, :plan, :rate, :first_time, :last_time

  def initialize(params:, set_hotel:)
    @params = params
    @set_hotel = set_hotel
    @key = JSON.parse(params[:key])
    @daily_rates = params.fetch(:daily_rates)
    @day = daily_rates.fetch(:day)
    @today_rest_rate = daily_rates.fetch(:rest_rates)
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
      update_daily_rest_rates
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
    set_hotel.days.update!(pick_day_id, day:)
  end

  def pick_day_id
    set_hotel.days.where(day:).pick(:id)
  end

  # TODO:updated_atが更新されてしまう
  def update_daily_rest_rates
    update_day.rest_rates.update!(pick_rest_rate_id, plan:, rate:, first_time:, last_time:)
  end

  def pick_rest_rate_id
    update_day.rest_rates.where(plan:).pick(:id)
  end
end
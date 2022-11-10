# frozen_string_literal: true

class HotelSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :content,
             :average_rating,
             :reviews_count,
             :hotel_images,
             :day_of_the_week,
             :rest_rates,
             :stay_rates

  def hotel_images
    ActiveModelSerializers::SerializableResource.new(
      object.hotel_images,
      each_serializer: HotelImageSerializer,
      adapter: :attributes
    ).serializable_hash
  end

  def day_of_the_week
    ActiveModelSerializers::SerializableResource.new(
      select_a_day,
      each_serializer: DaySerializer,
      adapter: :attributes
    ).serializable_hash
  end

  def rest_rates
    return '営業時間外です' if during_business_hours_rest_list.blank?

    ActiveModelSerializers::SerializableResource.new(
      pick_up_a_rest,
      each_serializer: RestRateSerializer,
      adapter: :attributes
    ).serializable_hash
  end

  def stay_rates
    return '営業時間外です' if during_business_hours_stay_list.blank?

    ActiveModelSerializers::SerializableResource.new(
      pick_up_a_stay,
      each_serializer: StayRateSerializer,
      adapter: :attributes
    ).serializable_hash
  end

  DAYS = %w[日曜 月曜 火曜 水曜 木曜 金曜 土曜].freeze

  private

    def pick_up_a_rest
      filtered_cheap_rest_rates.where(id: select_a_long_rest_time_service)
    end

    def pick_up_a_stay
      # 朝の6時以降かつ今の時間が宿泊の開始時刻ではない場合
      return the_next_start_stay_service if StayRate.the_time_now_is_after_6_am? && aftet_stay_time

      p aftet_stay_time
      filtered_cheap_stay_rates.where(id: select_a_long_stay_time_service)
    end

    def aftet_stay_time
      during_business_hours_stay_list.pluck(:start_time, :id)&.map do |val|
        arr = []
        arr << val[1] << aftet_business_hours(start_time: val[0])
      end
    end

    def aa
      after_stay_time.filter do |id, bool|
        if bool
          during_business_hours_stay_list.where(id: id)
        end
      end
    end

    def aftet_business_hours(start_time:)
      [*convert_at_hour(start_time)..23].none?(convert_at_hour(Time.current))
    end

    def convert_at_hour(time)
      (I18n.l time, format: :hours).to_i
    end

    def the_next_start_stay_service
      during_business_hours_stay_list.where(id: StayRate.select_the_next_start_stay_id(stay_rates: during_business_hours_stay_list))
    end

    def select_a_long_rest_time_service
      HotelBusinessHour.select_the_longest_business_hour_service_id(cheap_services: filtered_cheap_rest_rates)
    end

    def select_a_long_stay_time_service
      HotelBusinessHour.select_the_longest_business_hour_service_id(cheap_services: filtered_cheap_stay_rates)
    end


    def filtered_cheap_rest_rates
      during_business_hours_rest_list.where(rate: during_business_hours_rest_list.pluck(:rate).min)
    end

    def filtered_cheap_stay_rates
      during_business_hours_stay_list.where(rate: during_business_hours_stay_list.pluck(:rate).min)
    end

    def during_business_hours_rest_list
      object.rest_rates.where(id: take_rest_rates_list.select(&:present?))
    end

    def during_business_hours_stay_list
      object.stay_rates.where(id: take_stay_rates_list.select(&:present?))
    end

    def take_rest_rates_list
      HotelBusinessHour.take_services_list(today_rate_list: RestRate.where(day_id: select_a_day.ids))
    end

    def take_stay_rates_list
      HotelBusinessHour.take_services_list(today_rate_list: StayRate.where(day_id: select_a_day.ids))
    end

    def select_a_day
      return Day.special_day.where(hotel_id: object.id) if SpecialPeriod.check_today_is_a_special_period?(hotel: object)

      Day.select_a_day_of_the_week.where(hotel_id: object.id)
    end
end

# frozen_string_literal: true

class StayBusinessHour
  attr_reader :stay_rates_of_the_hotel
  private :stay_rates_of_the_hotel

  # 現在時刻からトップページに表示する宿泊料金を一つ表示する
  # 現在時刻にもっとも安いプランが複数ある場合は終了時刻までがより長い宿泊プランを一つ抽出
  # 現在時刻が宿泊時間外である場合は、現在時刻から次の宿泊料金の開始時刻までが最も短い宿泊プランを抽出
  # ホテルの締め時間が朝6時なので、たとえ朝6時が宿泊の営業時間内だとしても、無条件で今夜の宿泊プランを抽出する

  MAX_TIME = 24
  CLOSING_TIME = 6
  BEFORE_TODAY_STAY_START_TIME = 12
  TODAY_LAST_TIME = 23
  TODAY_FIRST_TIME = 0
  LAST_STAY_TIME = 5

  def initialize(stay_rates_of_the_hotel:)
    @stay_rates_of_the_hotel = stay_rates_of_the_hotel
    freeze
  end

  def extract_the_stay_rate
    return select_the_next_start_stay_rate if the_time_now_is_between_6_am_and_next_stay_time? || filtered_cheap_stay_rates.empty?
    return filtered_cheap_stay_rates if filtered_cheap_stay_rates.one?

    select_the_longest_business_hour_of_stay_rate
  end

  private

    def select_the_next_start_stay_rate
      StayRate.where(id: select_the_next_start_stay_id(stay_rates: stay_rates_of_the_hotel))
    end

    def select_the_longest_business_hour_of_stay_rate
      StayRate.where(id: select_the_longest_business_hour_service_id(cheap_services: filtered_cheap_stay_rates))
    end

    def filtered_cheap_stay_rates
      pick_during_business_hours_stay_list.where(rate: pick_during_business_hours_stay_list.pluck(:rate).min)
    end

    def pick_during_business_hours_stay_list
      StayRate.where(id: extract_during_business_hour_stay_list(today_stay_list: stay_rates_of_the_hotel).compact)
    end

    def extract_during_business_hour_stay_list(today_stay_list:)
      making_each_stay_array(stay_rates_of_the_hotel: today_stay_list).map do |val|
        at_this_time_can_stay?(start_time: val[0], end_time: val[1], stay_rate_id: val[2])
      end
    end

    def at_this_time_can_stay?(start_time:, end_time:, stay_rate_id:)
      if midnight_service?(start_time)
        making_midnight_service_time_array(first_time: start_time, last_time: end_time).include?(convert_at_hour(Time.current)) ? stay_rate_id : nil
      else
        making_normal_service_time_array(first_time: start_time, last_time: end_time).include?(convert_at_hour(Time.current)) ? stay_rate_id : nil
      end
    end

    def making_normal_service_time_array(first_time:, last_time:)
      [*convert_at_hour(first_time)..TODAY_LAST_TIME, *TODAY_FIRST_TIME...convert_at_hour(last_time)]
    end

    def making_midnight_service_time_array(first_time:, last_time:)
      [*convert_at_hour(first_time)...convert_at_hour(last_time)]
    end

    def midnight_service?(start_time)
      convert_at_hour(start_time) >= TODAY_FIRST_TIME && convert_at_hour(start_time) <= LAST_STAY_TIME
    end

    NowTimeStayService = Struct.new(:id, :stay_service_time_length)

    def making_list_of_service_length_and_service_id(cheap_services:)
      making_each_stay_array(stay_rates_of_the_hotel: cheap_services).map do |val|
        NowTimeStayService.new(val[2], generate_midnight_or_normal_length(start_time: val[0], end_time: val[1]))
      end
    end

    def making_each_stay_array(stay_rates_of_the_hotel:)
      stay_rates_of_the_hotel.pluck(:start_time, :end_time, :id)
    end

    def generate_midnight_or_normal_length(start_time:, end_time:)
      if midnight_service?(start_time)
        making_midnight_service_time_array(first_time: Time.current, last_time: end_time).length
      else
        making_normal_service_time_array(first_time: Time.current, last_time: end_time).length
      end
    end

    def select_the_longest_business_hour_service_id(cheap_services:)
      making_list_of_service_length_and_service_id(cheap_services:).max_by { |a| a[1] }&.first
    end

    def select_the_next_start_stay_id(stay_rates:)
      making_list_of_next_stay_service_ids_and_time_length_from_the_current_time(stay_rates:).min_by { |a| a[1] }&.first
    end

    def making_list_of_next_stay_service_ids_and_time_length_from_the_current_time(stay_rates:)
      making_each_stay_array(stay_rates_of_the_hotel: stay_rates).map do |val|
        NowTimeStayService.new(val[2], generate_midnight_or_normal_service_length(val[0]))
      end
    end

    def generate_midnight_or_normal_service_length(start_time)
      midnight_service?(start_time) ? MAX_TIME : [*convert_at_hour(Time.current)...convert_at_hour(start_time)].length
    end

    def the_time_now_is_between_6_am_and_next_stay_time?(time = Time.current)
      return if select_today_first_stay_start_time.blank?
      
      convert_at_hour(time) >= CLOSING_TIME && convert_at_hour(time) <= select_today_first_stay_start_time
    end

    def today_stay_start_time
      making_each_stay_array(stay_rates_of_the_hotel:).map do |val|
        NowTimeStayService.new(val[2], generate_midnight_time_or_other_time_length(val[0]))
      end
    end

    def generate_midnight_time_or_other_time_length(start_time)
      midnight_service?(start_time) ? MAX_TIME : convert_at_hour(start_time)
    end

    def select_today_first_stay_start_time(stay_id_and_start_time = today_stay_start_time)
      stay_id_and_start_time.min_by { |a| a[1] }&.stay_service_time_length
    end

    def convert_at_hour(time)
      (I18n.l time, format: :hours).to_i
    end
end

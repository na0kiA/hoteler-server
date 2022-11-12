# frozen_string_literal: true

class StayBusinessHour
  attr_reader :date
  private :date

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

  def initialize(date:)
    @date = date
    freeze
  end

  def extract_the_stay_rate
    if the_time_now_is_between_6_am_and_next_stay_time || filtered_cheap_stay_rates.empty?
      StayRate.where(id: select_the_next_start_stay_id(stay_rates: date))
    elsif filtered_cheap_stay_rates.one?
      filtered_cheap_stay_rates
    else
      StayRate.where(id: select_the_longest_business_hour_service_id(cheap_services: filtered_cheap_stay_rates))
    end
  end

  private

    def filtered_cheap_stay_rates
      during_business_hours_stay_list.where(rate: during_business_hours_stay_list.pluck(:rate).min)
    end

    def during_business_hours_stay_list
      StayRate.where(id: take_services_list(today_stay_list: date).compact)
    end

    def take_services_list(today_stay_list:)
      making_each_stay_array(date: today_stay_list).map do |val|
        can_take_at_midnight_or_daytime?(start_time: val[0], end_time: val[1], service: val[2])
      end
    end

    # 素泊まりプランなど0時から5時に始まるサービスか、日中のサービスか、それらを現在時刻から取得できるかどうか
    def can_take_at_midnight_or_daytime?(start_time:, end_time:, service:)
      if midnight_service?(start_time:)
        making_midnight_service_time_array(first_time: start_time, last_time: end_time).include?(convert_at_hour(Time.current)) ? service : nil
      else
        making_normal_service_time_array(first_time: start_time, last_time: end_time).include?(convert_at_hour(Time.current)) ? service : nil
      end
    end

    def midnight_service?(start_time:)
      convert_at_hour(start_time) >= TODAY_FIRST_TIME && convert_at_hour(start_time) <= LAST_STAY_TIME
    end

    def create_array_of_service_length_and_service_id(cheap_services:)
      making_each_stay_array(date: cheap_services).map do |val|
        arr = []
        arr << val[2] << generate_midnight_or_normal_length(start_time: val[0], end_time: val[1])
      end
    end

    def making_each_stay_array(date:)
      date.pluck(:start_time, :end_time, :id)
    end

    def generate_midnight_or_normal_length(start_time:, end_time:)
      if midnight_service?(start_time:)
        making_midnight_service_time_array(first_time: Time.current, last_time: end_time).length
      else
        making_normal_service_time_array(first_time: Time.current, last_time: end_time).length
      end
    end

    def making_normal_service_time_array(first_time:, last_time:)
      [*convert_at_hour(first_time)..TODAY_LAST_TIME, *TODAY_FIRST_TIME...convert_at_hour(last_time)]
    end

    def making_midnight_service_time_array(first_time:, last_time:)
      [*convert_at_hour(first_time)...convert_at_hour(last_time)]
    end

    def select_the_longest_business_hour_service_id(cheap_services:)
      create_array_of_service_length_and_service_id(cheap_services:).max_by { |a| a[1] }&.first
    end

    def select_the_next_start_stay_id(stay_rates:)
      create_list_of_id_and_time_length_from_the_current_time(stay_rates:).min_by { |a| a[1] }&.first
    end

    def create_list_of_id_and_time_length_from_the_current_time(stay_rates:)
      making_each_stay_array(date: stay_rates).map do |val|
        arr = []
        arr << val[2] << if midnight_service?(start_time: val[0])
                           MAX_TIME
                         else
                           [*convert_at_hour(Time.current)...convert_at_hour(val[0])].length
                         end
      end
    end

    # ホテルの締め時間は朝6時なので,6時以降に表示する宿泊プランは今夜の宿泊プランの必要がある。そして次の最初の宿泊時間までは、その最初の宿泊プランを表示する
    def the_time_now_is_between_6_am_and_next_stay_time(time = Time.current)
      p select_today_first_stay_start_time
      convert_at_hour(time) >= CLOSING_TIME && convert_at_hour(time) <= select_today_first_stay_start_time
    end

    def today_stay_start_time
      making_each_stay_array(date:).map do |val|
        arr = []
        arr << val[2] << if midnight_service?(start_time: val[0])
                           MAX_TIME
                         else
                           convert_at_hour(val[0])
                         end
      end
    end

    def select_today_first_stay_start_time(stay_id_and_start_time = today_stay_start_time)
      stay_id_and_start_time.min_by { |a| a[1] }&.second
    end

    def convert_at_hour(time)
      (I18n.l time, format: :hours).to_i
    end
end

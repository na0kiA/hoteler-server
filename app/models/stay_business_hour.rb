# frozen_string_literal: true

class StayBusinessHour

  private attr_reader :date

  # 現在時刻からトップページに表示する宿泊料金を一つ表示する
  # 現在時刻にもっとも安いプランが複数ある場合は終了時刻までがより長い宿泊プランを一つ抽出
  # 現在時刻が宿泊時間外である場合は、現在時刻から宿泊料金の開始時刻までが最も短い宿泊プランを抽出
  # ホテルの締め時間が朝6時なので、たとえ朝6時が宿泊の営業時間内だとしても、無条件で次の夜の宿泊プランを抽出する

  MAX_TIME = 24
  CLOSING_TIME = 6
  BEFORE_TODAY_STAY_START_TIME = 12
  TODAY_LAST_TIME = 23
  TODAY_FIRST_TIME = 0

  def initialize(date:)
    @date = date
  end

  def extract_the_stay_rate
    if the_time_now_is_after_6_am || filtered_cheap_stay_rates.empty?
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
      StayRate.where(id: take_services_list(today_rate_list: date).compact)
    end

    def take_services_list(today_rate_list:)
      today_rate_list.pluck(:start_time, :end_time, :id)&.map do |val|
        can_take_at_midnight_or_daytime?(start_time: val[0], end_time: val[1], service: val[2])
      end
    end

    # 素泊まりプランなど0時から5時に始まるサービスか、日中のサービスかを現在時刻から取得できるかどうか
    def can_take_at_midnight_or_daytime?(start_time:, end_time:, service:)
      if midnight_service?(start_time:)
        # can_take_midnight_services_or_not(start_time:, end_time:, service:)
        making_midnight_service_time_array(first_time: start_time, last_time: end_time).include?(convert_at_hour(Time.current)) ? service : nil
      else
        # can_take_at_daytime_services_or_not(start_time:, end_time:, service:)
        making_normal_service_time_array(first_time: start_time, last_time: end_time).include?(convert_at_hour(Time.current)) ? service : nil
      end
    end

    def midnight_service?(start_time:)
      convert_at_hour(start_time) >= 0 && convert_at_hour(start_time) <= 5
    end

    # 夜21時から翌朝9時までのサービスに対応するために今が営業時間かどうか調べている
    # サービス終了時刻は〇〇時59分までなので終了時間までに範囲オブジェクトは...を使用
    # def can_take_at_daytime_services_or_not(start_time:, end_time:, service:)
    #   making_normal_service_time_array(first_time: start_time, last_time: end_time).include?(convert_at_hour(Time.current)) ? service : nil
    # end

    # def can_take_midnight_services_or_not(start_time:, end_time:, service:)
    #   making_midnight_service_time_array(first_time: start_time, last_time: end_time).include?(convert_at_hour(Time.current)) ? service : nil
    # end

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
      create_list_of_id_and_time_length_from_the_current_time(stay_rates:).min_by { |a| a[1] }.first
    end

    def create_list_of_id_and_time_length_from_the_current_time(stay_rates:)
      stay_rates.pluck(:start_time, :end_time, :id)&.map do |val|
        arr = []
        arr << val[2] << filtered_stay_service_at_current_time(start_time: val[0])
      end
    end

    def filtered_stay_service_at_current_time(start_time:)
      if midnight_service?(start_time:)
        MAX_TIME
      else
        [*convert_at_hour(Time.current)...convert_at_hour(start_time)].length
      end
    end

    # ホテルの締め時間は朝6時なので,6時以降に表示する宿泊プランは今日の宿泊プランの必要がある
    def the_time_now_is_after_6_am(time = Time.current)
      convert_at_hour(time) >= CLOSING_TIME && convert_at_hour(time) <= BEFORE_TODAY_STAY_START_TIME
    end


    def convert_at_hour(time)
      (I18n.l time, format: :hours).to_i
    end
end

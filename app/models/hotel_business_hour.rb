# frozen_string_literal: true

class HotelBusinessHour
  include ConvertAtHour

  class << self
    def take_services_list(today_rate_list:)
      today_rate_list.pluck(:start_time, :end_time, :id)&.map do |val|
        can_take_at_midnight_or_daytime?(start_time: val[0], end_time: val[1], service: val[2])
      end
    end

    # 深夜休憩や素泊まりプランなど0時から5時に始まるサービスが利用できるかどうか調べている。
    def can_take_at_midnight_or_daytime?(start_time:, end_time:, service:)
      if midnight_service?(start_time:)
        can_take_midnight_services_or_not(start_time:, end_time:, service:)
      else
        can_take_at_daytime_services_or_not(start_time:, end_time:, service:)
      end
    end

    def midnight_service?(start_time:)
      convert_at_hour(start_time) >= 0 && convert_at_hour(start_time) <= 5
    end

    # 夜21時から翌朝9時までのサービスに対応するために今が営業時間かどうか調べている
    # サービス終了時刻は〇〇時59分までなので終了時間までに範囲オブジェクトは...を使用
    def can_take_at_daytime_services_or_not(start_time:, end_time:, service:)
      [*convert_at_hour(start_time)..23, *0...convert_at_hour(end_time)].include?(convert_at_hour(Time.current)) ? service : nil
    end

    def can_take_midnight_services_or_not(start_time:, end_time:, service:)
      [*convert_at_hour(start_time)...convert_at_hour(end_time)].include?(convert_at_hour(Time.current)) ? service : nil
    end

    def create_array_of_service_length_and_service_id(cheap_services:)
      cheap_services.pluck(:start_time, :end_time, :id)&.map do |val|
        arr = []
        arr << val[2] << if midnight_service?(start_time: val[0])
                           take_a_midnight_service_length(end_time: val[1])
                         else
                           take_a_normal_service_length(end_time: val[1])
                         end
      end
    end

    def select_the_longest_business_hour_service_id(cheap_services:)
      create_array_of_service_length_and_service_id(cheap_services:).max_by { |a| a[1] }.first
    end

    def take_a_midnight_service_length(end_time:)
      [*convert_at_hour(Time.current)...convert_at_hour(end_time)].length
    end

    def take_a_normal_service_length(end_time:)
      [*convert_at_hour(Time.current)..23, *0...convert_at_hour(end_time)].length
    end
  end
end

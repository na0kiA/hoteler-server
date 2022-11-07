# frozen_string_literal: true

class BusinessHour
  class << self
    def take_services_list(today_rate_list:)
      today_rate_list.pluck(:start_time, :end_time, :id)&.map do |val|
        can_take_at_midnight_or_daytime?(start_time: val[0], end_time: val[1], service: RestRate.find(val[2]))
      end
    end

    # 深夜休憩や素泊まりプランなど0時から5時に始まるサービスが利用できるかどうか調べている。
    def can_take_at_midnight_or_daytime?(start_time:, end_time:, service:)
      if convert_at_hour(start_time) >= 0 && convert_at_hour(start_time) <= 5
        can_take_midnight_services_or_not(start_time:, end_time:, service:)
      else
        can_take_at_daytime_services_or_not(start_time:, end_time:, service:)
      end
    end

    # 夜21時から翌朝9時までのサービスに対応するために今が営業時間かどうか調べている
    # サービス終了時刻は〇〇時59分までなので終了時間までに範囲オブジェクトは...を使用
    def can_take_at_daytime_services_or_not(start_time:, end_time:, service:)
      [*convert_at_hour(start_time)..23, *0...convert_at_hour(end_time)].include?(convert_at_hour(Time.current)) ? service : nil
    end

    def can_take_midnight_services_or_not(start_time:, end_time:, service:)
      [*convert_at_hour(start_time)...convert_at_hour(end_time)].include?(convert_at_hour(Time.current)) ? service : nil
    end

    def convert_at_hour(time)
      (I18n.l time, format: :hours).to_i
    end
  end
end

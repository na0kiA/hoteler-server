class BusinessHour
  
  def self.can_take_service_list(today_rate_list)
    today_rate_list.pluck(:first_time, :last_time, :id)&.map do |val|

      # 深夜休憩や素泊まりプランなど0時から5時に始まるサービスが利用できるかどうか調べている。
      if convert_at_hour(time: val[0]) >= 0 && convert_at_hour(time: val[0]) <= 5
        can_take_a_midnight_service_or_not(first_time: val[0], last_time: val[1], ids: val[2])
      else
        can_take_a_daytime_service_or_not(first_time: val[0], last_time: val[1], ids: val[2])
      end
    end
  end

  private

  # サービス終了時刻は〇〇時59分までなので範囲オブジェクトは...を使用
  # 夜21時から翌朝9時までのサービスに対応するために[first..23, *0...last]のようにして今が営業時間かどうか調べている
  def can_take_a_daytime_service_or_not(first_time:, last_time:, id:)
    [*convert_at_hour(time: first_time)..23, *0...convert_at_hour(time: last_time)].include?(convert_at_hour(time: Time.current)) ? id : nil
  end

  def can_take_a_midnight_service_or_not(first_time:, last_time:, id:)
    [*convert_at_hour(time: first_time)...convert_at_hour(time: last_time)].include?(convert_at_hour(time: Time.current)) ? id : nil
  end

  def convert_at_hour(time:)
    (I18n.l time, format: :hours).to_i
  end
end
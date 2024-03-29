# frozen_string_literal: true

class RestBusinessHour
  attr_reader :date
  private :date

  # 現在時刻からトップページに表示する休憩料金を一つ表示する
  # 休憩時間外である場合は"営業時間外です"を表示する
  # もっとも安いプランを抽出
  # もっとも安いプランが一つの場合はそれを出力
  # もっとも安いプランが複数の場合は現在時刻からその休憩料金の終了時刻までが最も長いプランを抽出

  MAX_TIME = 24
  CLOSING_TIME = 6
  TODAY_LAST_TIME = 23
  TODAY_FIRST_TIME = 0
  REST_LAST_TIME = 5

  def initialize(date:)
    @date = date
    freeze
  end

  def extract_the_rest_rate
    if filtered_cheap_rest_rates.one? || filtered_cheap_rest_rates.empty?
      filtered_cheap_rest_rates
    else
      RestRate.where(id: select_the_longest_business_hour_service_id(cheap_services: filtered_cheap_rest_rates))
    end
  end

  private

    def filtered_cheap_rest_rates
      during_business_hours_rest_list.where(rate: during_business_hours_rest_list.pluck(:rate).min)
    end

    def during_business_hours_rest_list
      RestRate.where(id: take_services_list(today_rate_list: date).compact)
    end

    def take_services_list(today_rate_list:)
      making_each_rest_array(date: today_rate_list).map do |val|
        can_take_at_midnight_or_daytime?(start_time: val[0], end_time: val[1], service: val[2])
      end
    end

    def making_each_rest_array(date:)
      date.pluck(:start_time, :end_time, :id)
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
      convert_at_hour(start_time) >= TODAY_FIRST_TIME && convert_at_hour(start_time) <= REST_LAST_TIME
    end

    # 夜21時から翌朝9時までのサービスに対応するために今が営業時間かどうか調べている
    # サービス終了時刻は〇〇時59分までなので終了時間までの範囲オブジェクトは...を使用
    def can_take_at_daytime_services_or_not(start_time:, end_time:, service:)
      making_normal_service_time_array(first_time: start_time, last_time: end_time).include?(convert_at_hour(Time.current)) ? service : nil
    end

    def can_take_midnight_services_or_not(start_time:, end_time:, service:)
      making_midnight_service_time_array(first_time: start_time, last_time: end_time).include?(convert_at_hour(Time.current)) ? service : nil
    end

    def create_array_of_service_length_and_service_id(cheap_services:)
      making_each_rest_array(date: cheap_services).map do |val|
        arr = []
        arr << val[2] << generate_midnight_or_normal_length(start_time: val[0], end_time: val[1])
      end
    end

    def generate_midnight_or_normal_length(start_time:, end_time:)
      if midnight_service?(start_time:)
        take_a_midnight_service_length(end_time:)
      else
        take_a_normal_service_length(end_time:)
      end
    end

    def select_the_longest_business_hour_service_id(cheap_services:)
      create_array_of_service_length_and_service_id(cheap_services:).max_by { |a| a[1] }&.first
    end

    def take_a_midnight_service_length(end_time:)
      making_midnight_service_time_array(first_time: Time.current, last_time: end_time).length
    end

    def take_a_normal_service_length(end_time:)
      making_normal_service_time_array(first_time: Time.current, last_time: end_time).length
    end

    def making_midnight_service_time_array(first_time:, last_time:)
      [*convert_at_hour(first_time)...convert_at_hour(last_time)]
    end

    def making_normal_service_time_array(first_time:, last_time:)
      [*convert_at_hour(first_time)..TODAY_LAST_TIME, *TODAY_FIRST_TIME...convert_at_hour(last_time)]
    end

    def convert_at_hour(time)
      (I18n.l time, format: :hours).to_i
    end
end

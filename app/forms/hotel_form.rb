# frozen_string_literal: true

class HotelForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :content, :string
  attribute :key, :string
  attribute :user_id, :integer

  attribute :daily_rates
  attribute :special_periods

  with_options presence: true do
    with_options invalid_words: true do
      validates :name, length: { maximum: 50 }
      validates :content, length: { minimum: 10, maximum: 2000 }
    end
    validates :key, length: { minimum: 10 }
    validates :user_id
  end

  DAY_OF_WEEK = %w[月曜から木曜 金曜 土曜 日曜 祝日 祝前日 特別期間].freeze

  def save
    return if invalid?

    ActiveRecord::Base.transaction do
      hotel = Hotel.new(name:, content:, user_id:)
      build_hotel_images(hotel:)

      # DAY_OF_WEEK.map do |day_of_week|
        extracy_all_rest_rate_array.map do |val|
          days = hotel.days.build(day: %w[月曜から木曜 金曜 土曜 日曜 祝日 祝前日 特別期間])
          3.times { |num|
            days.rest_rates.build(plan:  val[num][:plan], rate: val[num][:rate], first_time: val[num][:first_time], last_time: val[num][:last_time])
          }
        end
      # end

      hotel.save!
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  def to_deep_symbol
    attributes.deep_symbolize_keys
  end

  private

    # 各曜日の休憩料金の数を算出する
   # counting_rest_rate = [3, 3, 3, 3, 3, 3, 3]
    def counting_rest_rate
      normal_period_rates.map do |num|
        num[:rest_rates].size
      end
    end

    # 全ての休憩料金を配列で出力する
    # [[{:plan=>"休憩90分", :rate=>3580, :first_time=>"6:00", :last_time=>"24:00"}, {:plan=>"休憩60分", :rate=>2580, :first_time=>"6:00", :last_time=>"19:00"}, {:plan=>"深夜休憩90分", :rate=>3580, :first_time=>"0:00", :last_time=>"5:00"}]...]
    def extracy_all_rest_rate_array
      normal_period_rates.pluck(:rest_rates)
    end

    def build_all_rest_rate(day:)
      extracy_all_rest_rate_array.map do |val|
        3.times { |num|
        day.rest_rates.build(plan:  val[num][:plan], rate: val[num][:rate], first_time: val[num][:first_time], last_time: val[num][:last_time])
        }
      end
    end



    def build_hotel_images(hotel:)
      JSON.parse(key).each do |val|
        hotel.hotel_images.build(key: val)
      end
    end

    def normal_period_rates
      daily_rates.values_at(:monday_through_thursday, :friday, :saturday, :sunday, :holiday, :day_before_a_holiday, :special_days)
    end

    def special_period_rates
      special_periods.values_at(:obon, :golden_week, :the_new_years_holiday)
    end

    def build_special_periods(special_day:)
      special_day.special_periods.build(period: special_period_rates[:period], start_date: special_period_rates[:start_date], end_date: special_period_rates[:end_date])
    end
end

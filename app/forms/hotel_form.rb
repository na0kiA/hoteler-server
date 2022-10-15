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

  DAY_OF_WEEK = [monday_through_thursday: '月曜から木曜', friday: '金曜', saturday: '土曜', sunday: '日曜', holiday: '祝日'].freeze

  def save
    return if invalid?
    p normal_period_rates
    p special_period_rates

    ActiveRecord::Base.transaction do
      hotel = Hotel.new(name:, content:, user_id:)
      build_hotel_images(hotel:)

      build_rest_rates_of_normal_days(hotel:)
      build_special_periods(special_day: build_hotel_days(hotel:, today: '特別期間'))
      hotel.save!
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  def to_deep_symbol
    attributes.deep_symbolize_keys
  end

  private

    def build_hotel_images(hotel:)
      JSON.parse(key).each do |val|
        hotel.hotel_images.build(key: val)
      end
    end

    # 各曜日ごとに休憩料金をbuild
    def build_rest_rates_of_normal_days(hotel:)
      DAY_OF_WEEK.each do |day|
        build_today_rest_rates(day_of_week: build_hotel_days(hotel:, today: day))
      end
    end

    def build_today_rest_rates(day_of_week:)
      day_of_week.rest_rates.build(plan: normal_period_rates[0][:plan], rate: normal_period_rates[0][:rate], first_time: normal_period_rates[0][:first_time], last_time: normal_period_rates[0][:last_time])
    end

    def build_hotel_days(hotel:, today:)
      hotel.days.build(day: today)
    end

    def build_rest_rates
      normal_period_rates.map do |each_rates|
        each_rates
      end
    end

    def normal_period_rates
      # [{:rest_rates=>[{:plan=>"休憩90分", :rate=>3980, :first_time=>"6:00", :last_time=>"1:00"}], :stay_rates=>[{:plan=>"宿泊1部", :rate=>6980, :first_time=>"6:00", :last_time=>"11:00"}]},
      #  {:rest_rates=>[{:plan=>"休憩90分", :rate=>3980, :first_time=>"6:00", :last_time=>"1:00"}], :stay_rates=>[{:plan=>"宿泊1部", :rate=>6980, :first_time=>"6:00", :last_time=>"11:00"}]}, 
      #  {:rest_rates=>[{:plan=>"休憩90分", :rate=>3980, :first_time=>"6:00", :last_time=>"1:00"}], :stay_rates=>[{:plan=>"宿泊1部", :rate=>6980, :first_time=>"6:00", :last_time=>"11:00"}]},
      #   {:rest_rates=>[{:plan=>"休憩90分", :rate=>3980, :first_time=>"6:00", :last_time=>"1:00"}], :stay_rates=>[{:plan=>"宿泊1部", :rate=>6980, :first_time=>"6:00", :last_time=>"11:00"}]}, 
      #   {:rest_rates=>[{:plan=>"休憩90分", :rate=>3980, :first_time=>"6:00", :last_time=>"1:00"}], :stay_rates=>[{:plan=>"宿泊1部", :rate=>6980, :first_time=>"6:00", :last_time=>"11:00"}]}]
      daily_rates.values_at(:monday_through_thursday, :friday, :saturday, :sunday, :holiday)
    end
    
    def special_period_rates
      special_periods.values_at(:obon, :golden_week, :the_new_years_holiday)
    end

    def build_special_periods(special_day:)
      special_day.special_periods.build(period: special_period_rates[:period], start_date: special_period_rates[:start_date], end_date: special_period_rates[:end_date])
    end
end
# frozen_string_literal: true
# # frozen_string_literal: true

# class HotelForm
#   include ActiveModel::Model
#   include ActiveModel::Attributes

#   attribute :name, :string
#   attribute :content, :string
#   attribute :key, :string
#   attribute :user_id, :integer

#   with_options presence: true do
#     with_options invalid_words: true do
#       validates :name, length: { maximum: 50 }
#       validates :content, length: { minimum: 10, maximum: 2000 }
#     end
#     validates :key, length: { minimum: 10 }
#     validates :user_id
#   end

#   def save
#     return if invalid?

#     ActiveRecord::Base.transaction do
#       hotel = Hotel.new(name:, content:, user_id:)
#       build_hotel_images(hotel:)
#       # build_normal_period_rest_rates(hotel:)

#       # build_special_period_and_rest_rate(hotel:)
#       hotel.save!
#     end
#   rescue ActiveRecord::RecordInvalid
#     false
#   end

#   def to_deep_symbol
#     attributes.deep_symbolize_keys
#   end

#   private

#     def build_hotel_images(hotel:)
#       JSON.parse(key).each do |val|
#         hotel.hotel_images.build(key: val)
#       end
#     end

#     # def normal_period_array
#     #   daily_rates.values_at(:monday_through_thursday, :friday, :saturday, :sunday, :holiday, :day_before_a_holiday, :special_days)
#     # end

#     # DailyRate = Struct.new(:monday_through_thursday, :friday, :saturday, :sunday, :holiday, :day_before_a_holiday, :special_days)

#     # def rest_rates_by_day_of_the_week
#     #   arr = normal_period_array.map do |period|
#     #     period.fetch(:rest_rates)
#     #   end
#     #   DailyRate.new(arr[0], arr[1], arr[2], arr[3], arr[4], arr[5], arr[6])
#     # end

#     # def build_normal_period_rest_rates(hotel:)
#     #   monday_through_thursday, friday, saturday, sunday, holiday, day_before_a_holiday = hotel.days.build(DAY_OF_THE_WEEK)

#     #   build_monday_through_thursday_rest_rate(day: monday_through_thursday)
#     #   build_friday_rest_rate(day: friday)
#     #   build_saturday_rest_rate(day: saturday)
#     #   build_sunday_rest_rate(day: sunday)
#     #   build_holiday_rest_rate(day: holiday)
#     #   build_day_before_a_holiday_rest_rate(day: day_before_a_holiday)
#     # end

#     # def build_rest_rate(day:, a_rest_rate:)
#     #   day.rest_rates.build(plan: a_rest_rate[:plan], rate: a_rest_rate[:rate], first_time: a_rest_rate[:first_time], last_time: a_rest_rate[:last_time])
#     # end

#     # def build_monday_through_thursday_rest_rate(day:)
#     #   rest_rates_by_day_of_the_week.monday_through_thursday.map do |a_rest_rate|
#     #     build_rest_rate(day:, a_rest_rate:)
#     #   end
#     # end

#     # def build_friday_rest_rate(day:)
#     #   rest_rates_by_day_of_the_week.friday.map do |a_rest_rate|
#     #     build_rest_rate(day:, a_rest_rate:)
#     #   end
#     # end

#     # def build_saturday_rest_rate(day:)
#     #   rest_rates_by_day_of_the_week.saturday.map do |a_rest_rate|
#     #     build_rest_rate(day:, a_rest_rate:)
#     #   end
#     # end

#     # def build_sunday_rest_rate(day:)
#     #   rest_rates_by_day_of_the_week.sunday.map do |a_rest_rate|
#     #     build_rest_rate(day:, a_rest_rate:)
#     #   end
#     # end

#     # def build_holiday_rest_rate(day:)
#     #   rest_rates_by_day_of_the_week.holiday.map do |a_rest_rate|
#     #     build_rest_rate(day:, a_rest_rate:)
#     #   end
#     # end

#     # def build_day_before_a_holiday_rest_rate(day:)
#     #   rest_rates_by_day_of_the_week.day_before_a_holiday.map do |a_rest_rate|
#     #     build_rest_rate(day:, a_rest_rate:)
#     #   end
#     # end

#     # def build_special_period_and_rest_rate(hotel:)
#     #   day = hotel.days.build(day: '特別期間')

#     #   build_special_days_rest_rate(day:)
#     #   build_special_periods(day:)
#     # end

#     # def build_special_days_rest_rate(day:)
#     #   rest_rates_by_day_of_the_week.special_days.map do |a_rest_rate|
#     #     build_rest_rate(day:, a_rest_rate:)
#     #   end
#     # end

#     # def build_special_periods(day:)
#     #   return if special_periods.blank?

#     #   special_periods.values_at(:obon, :golden_week, :the_new_years_holiday).map do |val|
#     #     next if val.nil?

#     #     day.special_periods.build(period: val[:period], start_date: val[:start_date], end_date: val[:end_date])
#     #   end
#     # end
# end

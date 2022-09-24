class HotelDailyRate < ApplicationRecord
  belongs_to :hotel

  enum :day, { monday_through_thursday: 0,  friday: 10, saturday: 20, sunday: 30, holiday: 40, special_day: 50}
end
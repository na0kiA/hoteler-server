# frozen_string_literal: true

module HotelFormSpecHelper
  def daily_rate_params
    { monday_through_thursday:, friday:, saturday:, sunday:, holiday:, day_before_a_holiday:, special_days: }
  end

  def monday_through_thursday
    { rest_rates: [
      { plan: "休憩90分", rate: 3580, start_time: "6:00", end_time: "24:00" },
      { plan: "休憩60分", rate: 2580, start_time: "6:00", end_time: "19:00" },
      { plan: "深夜休憩90分", rate: 3580, start_time: "0:00", end_time: "5:00" }
    ],
      stay_rates: [
        { plan: "宿泊1部", rate: 5580, start_time: "20:00", end_time: "11:00" },
        { plan: "宿泊2部", rate: 6580, start_time: "22:00", end_time: "15:00" },
        { plan: "素泊まり", rate: 4580, start_time: "0:00", end_time: "10:00" }
      ] }
  end

  def friday
    { rest_rates: [
      { plan: "休憩90分", rate: 3980, start_time: "6:00", end_time: "24:00" },
      { plan: "休憩60分", rate: 2980, start_time: "6:00", end_time: "19:00" },
      { plan: "深夜休憩90分", rate: 3980, start_time: "0:00", end_time: "5:00" }
    ],
      stay_rates: [
        { plan: "宿泊1部", rate: 5980, start_time: "20:00", end_time: "11:00" },
        { plan: "宿泊2部", rate: 6980, start_time: "22:00", end_time: "15:00" },
        { plan: "素泊まり", rate: 4980, start_time: "0:00", end_time: "10:00" }
      ] }
  end

  def saturday
    { rest_rates: [
      { plan: "休憩90分", rate: 4980, start_time: "6:00", end_time: "24:00" },
      { plan: "休憩60分", rate: 3980, start_time: "6:00", end_time: "19:00" },
      { plan: "深夜休憩90分", rate: 4980, start_time: "0:00", end_time: "5:00" }
    ],
      stay_rates: [
        { plan: "宿泊1部", rate: 5980, start_time: "20:00", end_time: "11:00" },
        { plan: "宿泊2部", rate: 7980, start_time: "22:00", end_time: "15:00" }
      ] }
  end

  def sunday
    { rest_rates: [
      { plan: "休憩90分", rate: 4980, start_time: "6:00", end_time: "24:00" },
      { plan: "休憩60分", rate: 3980, start_time: "6:00", end_time: "19:00" },
      { plan: "深夜休憩90分", rate: 4980, start_time: "0:00", end_time: "5:00" }
    ],
      stay_rates: [
        { plan: "宿泊1部", rate: 4980, start_time: "20:00", end_time: "11:00" },
        { plan: "宿泊2部", rate: 5980, start_time: "22:00", end_time: "15:00" },
        { plan: "素泊まり", rate: 4980, start_time: "0:00", end_time: "10:00" }
      ] }
  end

  def holiday
    { rest_rates: [
      { plan: "休憩90分", rate: 4980, start_time: "6:00", end_time: "24:00" },
      { plan: "休憩60分", rate: 3980, start_time: "6:00", end_time: "19:00" },
      { plan: "深夜休憩90分", rate: 4980, start_time: "0:00", end_time: "5:00" }
    ],
      stay_rates: [
        { plan: "宿泊1部", rate: 4980, start_time: "20:00", end_time: "11:00" },
        { plan: "宿泊2部", rate: 5980, start_time: "22:00", end_time: "15:00" },
        { plan: "素泊まり", rate: 4980, start_time: "0:00", end_time: "10:00" }
      ] }
  end

  def day_before_a_holiday
    { rest_rates: [
      { plan: "休憩90分", rate: 4980, start_time: "6:00", end_time: "24:00" },
      { plan: "休憩60分", rate: 3980, start_time: "6:00", end_time: "19:00" },
      { plan: "深夜休憩90分", rate: 4980, start_time: "0:00", end_time: "5:00" }
    ],
      stay_rates: [
        { plan: "宿泊1部", rate: 5980, start_time: "20:00", end_time: "11:00" },
        { plan: "宿泊2部", rate: 7980, start_time: "22:00", end_time: "15:00" }
      ] }
  end

  def special_days
    { rest_rates: [
      { plan: "休憩90分", rate: 6980, start_time: "6:00", end_time: "24:00" },
      { plan: "休憩60分", rate: 5980, start_time: "6:00", end_time: "19:00" },
      { plan: "深夜休憩90分", rate: 5980, start_time: "0:00", end_time: "5:00" }
    ],
      stay_rates: [
        { plan: "宿泊1部", rate: 13_980, start_time: "20:00", end_time: "11:00" },
        { plan: "宿泊2部", rate: 14_980, start_time: "22:00", end_time: "15:00" }
      ] }
  end

  def special_period_params
    { obon: { period: "obon", start_date: "2022-08-08", end_date: "2022-08-15" }, golden_week: { period: "golden_week", start_date: "2022-05-02", end_date: "2022-05-01" },
      the_new_years_holiday: { period: "the_new_years_holiday", start_date: "2022-12-25", end_date: "2023-01-04" } }
  end
end

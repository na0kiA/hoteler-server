# frozen_string_literal: true

module HotelFormSpecHelper

  def daily_rate_params
    {monday_through_thursday:, friday:, saturday:, sunday:, holiday:, day_before_a_holiday:, special_days: }
  end

  def monday_through_thursday
    { rest_rates: [
      { plan: '休憩90分', rate: 3580, first_time: '6:00', last_time: '24:00' },
      { plan: '休憩60分', rate: 2580, first_time: '6:00', last_time: '19:00' },
      { plan: '深夜休憩90分', rate: 3580, first_time: '0:00', last_time: '5:00' }
    ],
      stay_rates: [
        { plan: '宿泊1部', rate: 5580, first_time: '20:00', last_time: '11:00' },
        { plan: '宿泊2部', rate: 6580, first_time: '22:00', last_time: '15:00' },
        { plan: '素泊まり', rate: 4580, first_time: '0:00', last_time: '10:00' }
      ] }
  end

  def friday
    { rest_rates: [
      { plan: '休憩90分', rate: 3980, first_time: '6:00', last_time: '24:00' },
      { plan: '休憩60分', rate: 2980, first_time: '6:00', last_time: '19:00' },
      { plan: '深夜休憩90分', rate: 3980, first_time: '0:00', last_time: '5:00' }
    ],
      stay_rates: [
        { plan: '宿泊1部', rate: 5980, first_time: '20:00', last_time: '11:00' },
        { plan: '宿泊2部', rate: 6980, first_time: '22:00', last_time: '15:00' },
        { plan: '素泊まり', rate: 4980, first_time: '0:00', last_time: '10:00' }
      ] }
  end

  def saturday
    { rest_rates: [
      { plan: '休憩90分', rate: 4980, first_time: '6:00', last_time: '24:00' },
      { plan: '休憩60分', rate: 3980, first_time: '6:00', last_time: '19:00' },
      { plan: '深夜休憩90分', rate: 4980, first_time: '0:00', last_time: '5:00' }
    ],
      start_rates: [
        { plan: '宿泊1部', rate: 5980, first_time: '20:00', last_time: '11:00' },
        { plan: '宿泊2部', rate: 7980, first_time: '22:00', last_time: '15:00' }
      ] }
  end

  def sunday
    { rest_rates: [
      { plan: '休憩90分', rate: 4980, first_time: '6:00', last_time: '24:00' },
      { plan: '休憩60分', rate: 3980, first_time: '6:00', last_time: '19:00' },
      { plan: '深夜休憩90分', rate: 4980, first_time: '0:00', last_time: '5:00' }
    ],
      stay_rates: [
        { plan: '宿泊1部', rate: 4980, first_time: '20:00', last_time: '11:00' },
        { plan: '宿泊2部', rate: 5980, first_time: '22:00', last_time: '15:00' },
        { plan: '素泊まり', rate: 4980, first_time: '0:00', last_time: '10:00' }
      ] }
  end

  def holiday
    { rest_rates: [
      { plan: '休憩90分', rate: 4980, first_time: '6:00', last_time: '24:00' },
      { plan: '休憩60分', rate: 3980, first_time: '6:00', last_time: '19:00' },
      { plan: '深夜休憩90分', rate: 4980, first_time: '0:00', last_time: '5:00' }
    ],
      stay_rates: [
        { plan: '宿泊1部', rate: 4980, first_time: '20:00', last_time: '11:00' },
        { plan: '宿泊2部', rate: 5980, first_time: '22:00', last_time: '15:00' },
        { plan: '素泊まり', rate: 4980, first_time: '0:00', last_time: '10:00' }
      ] }
  end

  def day_before_a_holiday
    { rest_rates: [
      { plan: '休憩90分', rate: 4980, first_time: '6:00', last_time: '24:00' },
      { plan: '休憩60分', rate: 3980, first_time: '6:00', last_time: '19:00' },
      { plan: '深夜休憩90分', rate: 4980, first_time: '0:00', last_time: '5:00' }
    ],
      start_rates: [
        { plan: '宿泊1部', rate: 5980, first_time: '20:00', last_time: '11:00' },
        { plan: '宿泊2部', rate: 7980, first_time: '22:00', last_time: '15:00' }
      ] }
  end

  def special_days
    { rest_rates: [
      { plan: '休憩90分', rate: 4980, first_time: '6:00', last_time: '24:00' },
      { plan: '休憩60分', rate: 3980, first_time: '6:00', last_time: '19:00' },
      { plan: '深夜休憩90分', rate: 4980, first_time: '0:00', last_time: '5:00' }
    ],
      start_rates: [
        { plan: '宿泊1部', rate: 5980, first_time: '20:00', last_time: '11:00' },
        { plan: '宿泊2部', rate: 7980, first_time: '22:00', last_time: '15:00' }
      ] }
  end

  def special_period_params
    { obon: { period: 1, start_date: '2022-08-08', end_date: '2022-08-15' }, golden_week: { period: 0, start_date: '2022-05-02', end_date: '2022-05-01' },
      the_new_years_holiday: { period: 2, start_date: '2022-12-25', end_date: '2023-01-04' } }
  end
end
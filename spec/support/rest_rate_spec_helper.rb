# frozen_string_literal: true

module RestRateSpecHelper
  def rest_rate_params
    {
      monday_through_thursday: rest_rate,
      friday: rest_rate,
      saturday: rest_rate,
      sunday: rest_rate,
      holiday: rest_rate,
      day_before_a_holiday: rest_rate,
      special_days: rest_rate
    }
  end

  # params = { rest_rate: {
  #         monday_through_thursday: rest_rates,
  #         friday: rest_rates,
  #         saturday: rest_rates,
  #         sunday: rest_rates,
  #         holiday: rest_rates,
  #         day_before_a_holiday: rest_rates,
  #         special_days: rest_rates
  #         }, day }

  def rest_rates
    [
      { plan: '休憩90分', rate: 3580, start_time: '6:00', end_time: '24:00' },
      { plan: '休憩60分', rate: 2580, start_time: '6:00', end_time: '19:00' },
      { plan: '深夜休憩90分', rate: 3580, start_time: '0:00', end_time: '5:00' }
    ]
  end
end

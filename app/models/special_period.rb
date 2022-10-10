# frozen_string_literal: true

class SpecialPeriod < ApplicationRecord
  belongs_to :day
  enum :periods, { golden_week: 0, obon: 1, the_new_years_holiday: 2 }
end

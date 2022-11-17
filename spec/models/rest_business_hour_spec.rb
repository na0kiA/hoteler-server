# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RestBusinessHour, type: :model do
  describe 'models/rest_business_hour.rb #extract_the_rest_rate' do
    let_it_be(:user) { create(:user) }
    let_it_be(:hotel) { create(:completed_profile_hotel, :with_days_and_service_rates, user_id: user.id) }

    context '今が月曜の深夜4時で、深夜休憩と早朝休憩の料金が同じ場合' do
      let_it_be(:morning_rest_rate) { create(:rest_rate, :morning_rest_rate, day_id: hotel.days.ids[0]) }

      before do
        travel_to Time.zone.local(2022, 11, 14, 4, 0, 0)
      end

      it '現在営業中の休憩料金の中から最安かつ、休憩終了時刻までが最も長い休憩プランを一つ抽出できること' do
        monday_through_thursday_id = hotel.days.ids[0]
        day_before_a_holiday_rest_rates = hotel.rest_rates.where(day_id: monday_through_thursday_id)
        rest_business_hour = described_class.new(date: day_before_a_holiday_rest_rates)

        expect(rest_business_hour.extract_the_rest_rate[0][:plan]).to eq('早朝休憩90分')
        expect(rest_business_hour.extract_the_rest_rate[0][:rate]).to eq(4980)
      end
    end
  end
end

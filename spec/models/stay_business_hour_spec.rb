# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StayBusinessHour, type: :model do
  describe 'models/stay_business_hour.rb #extract_the_stay_rate' do
    let_it_be(:user) { create(:user) }
    let_it_be(:hotel) { create(:completed_profile_hotel, :with_days_and_service_rates, user_id: user.id) }

    context '今日が祝前日の13時の場合' do
      before do
        travel_to Time.zone.local(2022, 11, 2, 13, 0, 0)
      end

      it '現在時刻から最も宿泊の開始時刻が近い、宿泊プランを一つ抽出できること' do
        day_before_a_holiday_rest_rates = hotel.stay_rates.where(day_id: hotel.days.ids[6])
        stay_business_hour = described_class.new(date: day_before_a_holiday_rest_rates)
        expect(stay_business_hour.extract_the_stay_rate[0][:plan]).to eq('宿泊1部')
        expect(stay_business_hour.extract_the_stay_rate[0][:rate]).to eq(12_980)
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RestRate, type: :model do
  describe 'models/rest_rate.rb #now_rest_rate' do
    let_it_be(:user) { create(:user) }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: user.id) }
    let_it_be(:weekdays) { create(:weekdays, hotel_id: accepted_hotel.id) }
    let_it_be(:rest_rate) { create(:rest_rate, day_id: weekdays.id) }
    let_it_be(:midnight_rate) { create(:midnight_rate, day_id: weekdays.id) }

    context '曜日が木曜日で、時刻が23時59分の場合' do
      before do
        travel_to Time.zone.local(2022, 10, 13, 6, 0, 0)
      end

      it '月曜から木曜に設定した休憩料金が表示されること' do
        expect(RestRate.new.send(:today_rest_rate_list)[0][:day_id]).to eq(weekdays.id)
        expect(RestRate.new.now_rest_rate[0][:plan]).to eq('休憩90分')
      end
    end
  end
end

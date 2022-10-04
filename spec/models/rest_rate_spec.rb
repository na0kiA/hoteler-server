# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RestRate, type: :model do
  describe 'models/rest_rate.rb #now_rest_rate' do
    let_it_be(:user) { create(:user) }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: user.id) }
    let_it_be(:day) { create(:day, hotel_id: accepted_hotel.id) }
    let_it_be(:rest_rate) { create(:rest_rate, day_id: day.id) }
    let_it_be(:midnight_rate) { create(:midnight_rate, day_id: day.id) }

    context '今の時間が休憩の営業時間内の場合' do
      it '該当するrest_rateを返すこと' do
        expect(RestRate.new.now_rest_rate).to eq('d')
      end
    end
  end
end

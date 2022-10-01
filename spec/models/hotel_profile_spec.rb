require 'rails_helper'

RSpec.describe HotelProfile, type: :model do
  describe 'models/hotel_profile.rb #update' do
    let_it_be(:user) { create(:user) }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: user.id)}
    let_it_be(:day) { create(:day, hotel_id: accepted_hotel.id)}
    let_it_be(:rest_rate) { create(:rest_rate, day_id: day.id)}

    context '正常に更新ができる場合' do
      it 'paramsの値が更新されること' do
        params = { name:  "神戸北野", content:  "最高峰のラグジュアリーホテルをお届けします", key: "[\"key1998\"]", user_id: user.id, daily_rates: { day: "月曜から木曜", rest_rates: { plan: "休憩90分", rate: 3980, first_time: "6:00", last_time: "0:00"}}}

        hotel_profile = described_class.new(params:, set_hotel: accepted_hotel)
        expect(hotel_profile.send(:update_hotel)[:name]).to eq('神戸北野')
        expect(hotel_profile.send(:update_daily_rest_rates)[:plan]).to eq('休憩90分')
        expect(hotel_profile.update[:rate]).to eq(3980)
      end
    end

    context '正常に更新ができない場合' do
      it 'paramsの値が不正でrollbackされること' do
        params = { name:  "", content:  "", key: "[\"\"]", user_id: user.id, daily_rates: { day: "", rest_rates: { plan: "", rate: "", first_time: "", last_time: ""}}}

        hotel_profile = described_class.new(params:, set_hotel: accepted_hotel)
        expect(hotel_profile.update).to eq(false)
      end
    end
  end
end

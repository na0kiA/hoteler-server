# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HotelProfile, type: :model do
  describe 'models/hotel_profile.rb #update' do
    let_it_be(:hotel) { create(:completed_profile_hotel, :with_a_day_and_rest_rates) }
    let_it_be(:update_params) {
      { name: '神戸レジャー', content: '最高峰のラグジュアリーホテルをお届けします', key: %w[key2998 key3998], daily_rates: daily_rate_params, special_periods: special_period_params, user_id: hotel.user_id }
    }

    context '正常に更新ができる場合' do
      it 'nameが更新できること' do
        hotel_profile = described_class.new(params: update_params, set_hotel: hotel)
        expect(hotel_profile.send(:update_hotel)[:name]).to eq('神戸レジャー')
        expect(hotel_profile.update).to be_truthy
      end

      it 'keyが更新できること' do
        hotel_profile = described_class.new(params: update_params, set_hotel: hotel)
        hotel_profile.update
        expect(hotel.hotel_images.pick(:key)).to eq('key2998')
        expect(hotel.hotel_images.pluck(:key).length).to eq(2)
      end

      it '月曜から木曜の休憩料金が更新できること' do
        hotel_profile = described_class.new(params: update_params, set_hotel: hotel)
        hotel_profile.update
        monday_through_thursday_id = hotel.days.where(day: '月曜から木曜').ids
        expect(hotel.rest_rates.where(day_id: monday_through_thursday_id[0]).length).to eq(3)
        expect(hotel.rest_rates.where(day_id: monday_through_thursday_id[0]).last[:plan]).to eq('深夜休憩90分')
      end
    end

    # context 'nameが空の場合' do
    #   it 'rollbackされること' do
    #     invalid_params = { name: '', content: '料金を更新しました', key: %w[key1998 key1998], daily_rates: daily_rate_params, special_periods: special_period_params, user_id: hotel.user_id }

    #     hotel_profile = described_class.new(params: invalid_params, set_hotel: hotel)
    #     expect(hotel_profile.update).to eq(0)
    #   end
    # end
  end
end

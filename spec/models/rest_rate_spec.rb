# # frozen_string_literal: true

# require 'rails_helper'

# RSpec.describe RestRate, type: :model do
#   describe 'models/rest_rate.rb #now_rest_rate' do
#     let_it_be(:user) { create(:user) }
#     let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: user.id) }
#     let_it_be(:weekdays) { create(:day, :monday_through_thursday, hotel_id: accepted_hotel.id) }
#     let_it_be(:normal_rest_rate) { create(:rest_rate, :normal_rest_rate, day_id: weekdays.id) }
#     let_it_be(:midnight_rest_rate) { create(:rest_rate, :midnight_rest_rate, day_id: weekdays.id) }

#     context '曜日が木曜日で、時刻が23時59分の場合' do
#       before do
#         travel_to Time.zone.local(2022, 10, 13, 6, 0, 0)
#       end

#       it '通常の休憩料金が表示されること' do
#         expect(RestRate.new.send(:today_rest_rate_list)[0][:day_id]).to eq(weekdays.id)
#         expect(RestRate.new.now_rest_rate[0][:plan]).to eq('休憩90分')
#       end

#       it '深夜休憩が表示されないこと' do
#         expect(RestRate.new.now_rest_rate[0][:plan]).not_to eq('深夜休憩90分')
#       end
#     end

#     context '曜日が木曜日で、時刻が0時00分の場合' do
#       before do
#         travel_to Time.zone.local(2022, 10, 13, 0, 0, 0)
#       end

#       it '深夜料金が表示されること' do
#         expect(RestRate.new.send(:today_rest_rate_list)[0][:day_id]).to eq(weekdays.id)
#         expect(RestRate.new.now_rest_rate[0][:plan]).to eq('深夜休憩90分')
#       end

#       it '通常の休憩料金が表示されないこと' do
#         expect(RestRate.new.now_rest_rate[0][:plan]).not_to eq('休憩90分')
#       end
#     end

#     context '曜日が木曜日で、時刻が5時01分の場合' do
#       before do
#         travel_to Time.zone.local(2022, 10, 13, 5, 0o1, 0)
#       end

#       it '営業時間外であること' do
#         expect(RestRate.new.send(:today_rest_rate_list)).to eq([normal_rest_rate, midnight_rest_rate])
#         expect(RestRate.new.now_rest_rate[0]).to be_nil
#       end

#       it '通常の休憩料金が表示されないこと' do
#         expect(RestRate.new.now_rest_rate).not_to include('休憩90分')
#       end
#     end

#     context '曜日が金曜日で、時刻が0時00分の場合' do
#       before do
#         travel_to Time.zone.local(2022, 10, 13, 5, 59, 0)
#       end

#       it '営業時間外であること' do
#         expect(RestRate.new.send(:today_rest_rate_list)).to eq([normal_rest_rate, midnight_rest_rate])
#         expect(RestRate.new.now_rest_rate[0]).to be_nil
#       end

#       it '通常の休憩料金が表示されないこと' do
#         expect(RestRate.new.now_rest_rate).not_to include('休憩90分')
#       end
#     end

#     # context '今日が特別期間の6時00分の場合' do
#     #   let_it_be(:special_week_rest_rate) { create(:special_week_rest_rate) }

#     #   before do
#     #     travel_to Time.zone.local(2022, 12, 25, 6, 0, 0)
#     #   end

#     #   it '特別料金が表示されること' do
#     #     expect(RestRate.new.now_rest_rate[0][:plan]).to eq('休憩90分')
#     #     expect(RestRate.new.now_rest_rate[0][:rate]).to eq(5980)
#     #   end

#     #   it '通常の休憩料金が表示されないこと' do
#     #     expect(RestRate.new.now_rest_rate[0][:rate]).not_to eq(3980)
#     #   end
#     # end
#   end
# end

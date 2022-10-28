# frozen_string_literal: true
# # frozen_string_literal: true

# require 'rails_helper'

# RSpec.describe HotelForm, type: :model do
#   describe 'models/hotel_form.rb #validation' do
#     let_it_be(:user) { create(:user) }

#     context '入力値が正常な場合' do
#       it 'name, content, hotel_images, daily_ratesのparamsがあること' do
#         params = { name: 'Hotel Kobe', content: 'このホテルは北野坂で最近できたホテルで..', key: ['upload/test', 'upload/test2'], daily_rates: daily_rate_params, user_id: user.id }
#         hotel_form = described_class.new(attributes: params, user_id: user.id)
#         expect(hotel_form).to be_valid
#       end

#       it 'nameが50文字、contentが2000文字入力できること' do
#         max_length_params = { name: 'Hotel' * 10, content: 'Hotel' * 400, key: ['upload/test', 'upload/test2'], daily_rates: daily_rate_params, user_id: user.id }
#         hotel_form = described_class.new(attributes: max_length_params, user_id: user.id)
#         expect(hotel_form).to be_valid
#       end
#     end

#     context '入力値が異常な場合' do
#       it 'nameとcontentが無ければエラーを返すこと' do
#         nil_params = { name: '', content: '', key: ['upload/test', 'upload/test2'], daily_rates: daily_rate_params, user_id: user.id }
#         hotel_form = described_class.new(attributes: nil_params, user_id: user.id)
#         hotel_form.valid?
#         expect(hotel_form).to be_invalid
#         expect(hotel_form.errors.messages[:name]).to eq ['ホテル名を入力してください。']
#         expect(hotel_form.errors.messages[:content]).to eq ['内容を入力してください。', '内容は10文字以上入力してください。']
#       end

#       it 'nameが51文字、contentが2001文字入力できないこと' do
#         too_length_params = { name: "#{'Hotel' * 10}1", content: "#{'Hotel' * 400}1", key: ['upload/test', 'upload/test2'], daily_rates: daily_rate_params, user_id: user.id }
#         hotel_form = described_class.new(attributes: too_length_params, user_id: user.id)
#         hotel_form.valid?
#         expect(hotel_form).to be_invalid
#       end
#     end
#   end

#   describe 'models/hotel_form.rb #save' do
#     let_it_be(:user) { create(:user) }
#     let_it_be(:hotel_params) { { name: '神戸北野', content: '最高峰のラグジュアリーホテルをお届けします', key: %w[key1998 key1998], daily_rates: daily_rate_params, special_periods: special_period_params, user_id: user.id } }

#     context '全ての値が保存できる場合' do
#       it 'Hotelが1個、HotelImageが2個、Dayが7個、RestRateが21個更新されること' do
#         hotel_form = described_class.new(hotel_params)
#         expect(hotel_form.save).to be_truthy
#         expect {
#           hotel_form.save
#         }.to change(Hotel,
#                     :count).by(1).and change(HotelImage, :count).by(2).and change(Day, :count).by(7).and change(RestRate, :count).by(21)
#       end

#       it '特別期間の料金が3つ保存されていること' do
#         described_class.new(hotel_params).save
#         expect(RestRate.where(day_id: Day.where(day: '特別期間')).length).to eq(3)
#       end
#     end

#     context '特別期間の料金と日程を設定する場合' do
#       it '特別期間を3つ登録できること' do
#         hotel_form = described_class.new(hotel_params)
#         expect(hotel_form.save).to be_truthy
#         expect {
#           hotel_form.save
#         }.to change(SpecialPeriod, :count).by(3)
#       end

#       it '登録した特別期間3つとも、同じday_idを持つこと' do
#         described_class.new(hotel_params).save
#         special_period_day_ids = SpecialPeriod.eager_load(:day).pluck(:day_id)
#         day_id = SpecialPeriod.eager_load(:day).pick(:day_id)
#         expect(special_period_day_ids).to eq([day_id, day_id, day_id])
#       end

#       it 'GWとお盆と年末年始の特別期間が登録されていること' do
#         described_class.new(hotel_params).save
#         special_period_date = SpecialPeriod.eager_load(:day).pluck(:period)
#         expect(special_period_date).to eq(%w[obon golden_week the_new_years_holiday])
#       end

#       it '特別期間の開始日付が登録されていること' do
#         described_class.new(hotel_params).save
#         obon, golden_week, the_new_years_holiday = SpecialPeriod.eager_load(:day).pluck(:start_date)
#         expect(I18n.l(obon)).to eq('08/08')
#         expect(I18n.l(golden_week)).to eq('05/02')
#         expect(I18n.l(the_new_years_holiday)).to eq('12/25')
#       end
#     end

#     context '特別期間を1個だけ設定する場合' do
#       let_it_be(:no_special_period_params) { { name: '神戸北野', content: '最高峰のラグジュアリーホテルをお届けします', key: %w[key1998 key1998], daily_rates: daily_rate_params, user_id: user.id } }
#       let_it_be(:obon) { { special_periods: { obon: { period: 1, start_date: '2022-08-08', end_date: '2022-08-15' } } } }

#       it '特別期間を1個だけ保存できること' do
#         described_class.new(no_special_period_params.merge(obon)).save
#         start_date = SpecialPeriod.eager_load(:day).pluck(:start_date)
#         expect(start_date.length).to eq(1)
#       end
#     end

#     context '特別期間を2個設定する場合' do
#       let_it_be(:no_special_period_params) { { name: '神戸北野', content: '最高峰のラグジュアリーホテルをお届けします', key: %w[key1998 key1998], daily_rates: daily_rate_params, user_id: user.id } }
#       let_it_be(:two_special_periods) {
#         { special_periods: { obon: { period: 1, start_date: '2022-08-08', end_date: '2022-08-15' }, the_new_years_holiday: { period: 2, start_date: '2022-12-25', end_date: '2023-01-04' } } }
#       }

#       it '特別期間を2個保存できること' do
#         described_class.new(no_special_period_params.merge(two_special_periods)).save
#         start_date = SpecialPeriod.eager_load(:day).pluck(:start_date)
#         expect(start_date.length).to eq(2)
#         expect(I18n.l(start_date[0])).to eq('08/08')
#         expect(I18n.l(start_date[1])).to eq('12/25')
#       end
#     end

#     context '特別期間の料金を設定しない場合' do
#       let_it_be(:no_special_period_params) { { name: '神戸北野', content: '最高峰のラグジュアリーホテルをお届けします', key: %w[key1998 key1998], daily_rates: daily_rate_params, user_id: user.id } }

#       it 'ホテルを登録できるが、特別期間は登録されないこと' do
#         hotel_form = described_class.new(no_special_period_params)
#         expect {
#           hotel_form.save
#         }.to change(Hotel, :count).by(1)
#         expect {
#           hotel_form.save
#         }.not_to change(SpecialPeriod, :count)
#       end
#     end

#     context 'name,content,keyを入力していない場合' do
#       it 'ホテルを保存されないこと' do
#         invalid_params = { name: '', content: '', key: ['', ''], user_id: user.id }
#         hotel_form = described_class.new(invalid_params)
#         expect(hotel_form.save).to be_nil
#         expect { hotel_form.save }.not_to change(Hotel, :count)
#       end
#     end

#     context '料金を入力していない場合' do
#       it 'ホテルが保存されずにrollbackされること' do
#         rollback_params = { name: '神戸北野坂', content: '最高峰のラグジュアリーホテルをお届けします', key: %w[key1998 key1998], user_id: user.id }
#         hotel_form = described_class.new(rollback_params)
#         expect(hotel_form.save).to be_nil
#         expect { hotel_form.save }.not_to change(Hotel, :count)
#       end
#     end
#   end

#   describe 'models/hotel_form.rb #to_deep_symbol' do
#     let_it_be(:user) { create(:user) }

#     context '正常にjson_paramsをシンボルに変換できる場合' do
#       it 'シンボルを返すこと' do
#         json_params = { 'name' => '神戸三宮', 'content' => '2017年にリニューアルオープンしました', 'user_id' => user.id, 'key' => ['key1998'],
#                         'daily_rates' => { 'friday' => { 'rest_rates' => { 'plan' => '休憩90分', 'rate' => 4980, 'last_time' => '00:00', 'first_time' => '06:00' } } } }
#         hotel_form = described_class.new(json_params)
#         expect(hotel_form.to_deep_symbol[:daily_rates][:friday][:rest_rates][:plan]).to eq('休憩90分')
#       end
#     end
#   end
# end

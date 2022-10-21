# frozen_string_literal: true

require 'rails_helper'
# TODO: saveメソッドのテストが未完成

RSpec.describe HotelForm, type: :model do
  describe 'models/hotel_form.rb #validation' do
    let_it_be(:user) { create(:user) }

    context '入力値が正常な場合' do
      it 'nameとcontentとhotel_imagesがあれば正常なこと' do
        params = { name: 'Hotel Kobe', content: 'このホテルは北野坂で最近できたホテルで..', key: ['upload/test', 'upload/test2'], user_id: user.id }
        hotel_form = described_class.new(attributes: params, user_id: user.id)
        expect(hotel_form).to be_valid
      end

      it 'nameが50文字、contentが2000文字入力できること' do
        max_length_params = { name: 'Hotel' * 10, content: 'Hotel' * 400, key: ['upload/test', 'upload/test2'], user_id: user.id }
        hotel_form = described_class.new(attributes: max_length_params, user_id: user.id)
        expect(hotel_form).to be_valid
      end
    end

    context '入力値が異常な場合' do
      it 'nameとcontentが無ければエラーを返すこと' do
        nil_params = { name: '', content: '', key: ['upload/test', 'upload/test2'], user_id: user.id }
        hotel_form = described_class.new(attributes: nil_params, user_id: user.id)
        hotel_form.valid?
        expect(hotel_form).to be_invalid
        expect(hotel_form.errors.messages[:name]).to eq ['ホテル名を入力してください。']
        expect(hotel_form.errors.messages[:content]).to eq ['内容を入力してください。', '内容は10文字以上入力してください。']
      end

      it 'nameが51文字、contentが2001文字入力できないこと' do
        too_length_params = { name: "#{'Hotel' * 10}1", content: "#{'Hotel' * 400}1", key: ['upload/test', 'upload/test2'], user_id: user.id }
        hotel_form = described_class.new(attributes: too_length_params, user_id: user.id)
        hotel_form.valid?
        expect(hotel_form).to be_invalid
      end
    end
  end

  describe 'models/hotel_form.rb #save' do
    let_it_be(:user) { create(:user) }
    let_it_be(:json_params) { { name: '神戸北野', content: '最高峰のラグジュアリーホテルをお届けします', key: %w[key1998 key1998], daily_rates: daily_rate_params, special_periods: special_period_params, user_id: user.id } }
    
    context '全ての値が保存できる場合' do

      it 'Hotelが1個、HotelImageが2個、Dayが7個、RestRateが21個更新されること' do
        hotel_form = described_class.new(json_params)
        expect(hotel_form.save).to be_truthy
        expect {
          hotel_form.save
        }.to change(Hotel,
                    :count).by(1).and change(HotelImage, :count).by(2).and change(Day, :count).by(7).and change(RestRate, :count).by(21)
      end

      it '特別期間の料金が3つ保存されていること' do
        described_class.new(json_params).save
        expect(RestRate.where(day_id: Day.where(day: '特別期間')).length).to eq(3)
      end
    end

    context '特別期間の料金と日程を設定する場合' do
      it '特別期間を3つ登録できること' do
        hotel_form = described_class.new(json_params)
        expect(hotel_form.save).to be_truthy
        expect {
          hotel_form.save
        }.to change(SpecialPeriod, :count).by(3)
      end

      it '登録した特別期間3つとも、同じday_idを持つこと' do
        described_class.new(json_params).save
        special_period_day_ids = SpecialPeriod.eager_load(:day).pluck(:day_id)
        day_id = SpecialPeriod.eager_load(:day).pick(:day_id)
        expect(special_period_day_ids).to eq([day_id, day_id, day_id])
      end

      it 'GWとお盆と年末年始の特別期間が登録されていること' do
        described_class.new(json_params).save
        special_period_date = SpecialPeriod.eager_load(:day).pluck(:period)
        expect(special_period_date).to eq("s")
      end
    end

    context '正常に保存ができない場合' do
      it 'paramsの値が異常でnilが返ること' do
        invalid_params = { name: '', content: '', key: ['', ''],
                           daily_rates: { friday: { rest_rates: { plan: '', rate: '', first_time: '', last_time: '24:00' } } }, user_id: user.id }

        hotel_form = described_class.new(invalid_params)

        expect(hotel_form.save).to be_nil
        expect { hotel_form.save }.not_to change(Hotel, :count)
      end

      # it 'rollbackされること' do
      #   rollback_params = { name: '神戸北野坂', content: '最高峰のラグジュアリーホテルをお届けします', key: %w[key1998 key1998],
      #                       daily_rates: '', user_id: user.id }

      #   hotel_form = described_class.new(rollback_params)

      #   expect(hotel_form.save).to be_nil
      #   # expect { hotel_form.save }.not_to change(Hotel, :count)
      # end
    end
  end

  describe 'models/hotel_form.rb #to_deep_symbol' do
    let_it_be(:user) { create(:user) }

    context '正常にjson_paramsをシンボルに変換できる場合' do
      it 'シンボルを返すこと' do
        json_params = { 'name' => '神戸三宮', 'content' => '2017年にリニューアルオープンしました', 'user_id' => user.id, 'key' => ['key1998'],
                        'daily_rates' => { 'friday' => { 'rest_rates' => { 'plan' => '休憩90分', 'rate' => 4980, 'last_time' => '00:00', 'first_time' => '06:00' } } } }
        hotel_form = described_class.new(json_params)
        expect(hotel_form.to_deep_symbol[:daily_rates][:friday][:rest_rates][:plan]).to eq('休憩90分')
      end
    end
  end
end

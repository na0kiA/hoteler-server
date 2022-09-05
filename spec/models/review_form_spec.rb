require 'rails_helper'
# TODO: メソッドのテストが未完成

RSpec.describe ReviewForm, type: :model do
  describe 'models/review_form.rb #validation' do
    let_it_be(:user) { create(:user) }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: user.id) }

    context '入力値が正常な場合' do
      it 'titleとcontentとfive_star_rateが正常なこと' do
        params = { title: 'よかったです', content: '部屋が綺麗', five_star_rate: 5 }
        review_form = described_class.new(attributes: params, hotel_id: accepted_hotel.id, user_id: user.id)
        expect(review_form).to be_valid
      end

      it 'titleが30文字、contentが1000文字、入力できること' do
        max_length_params = { title: 'このホテル' * 6, content: '綺麗でした' * 200, five_star_rate: 5 }
        review_form = described_class.new(attributes: max_length_params, hotel_id: accepted_hotel.id, user_id: user.id)
        expect(review_form).to be_valid
      end
    end

    context '入力値が異常な場合' do
      it 'titleかcontentかfive_star_rateが無ければエラーを返すこと' do
        nil_params = { title: nil, content: nil, five_star_rate: nil }
        review_form = described_class.new(attributes: nil_params, hotel_id: accepted_hotel.id, user_id: user.id)
        review_form.valid?
        expect(review_form).to be_invalid
        expect(review_form.errors.messages[:title]).to eq ['タイトルを入力してください。', 'タイトルは2文字以上入力してください。']
        expect(review_form.errors.messages[:content]).to eq ['内容を入力してください。', '内容は5文字以上入力してください。']
        expect(review_form.errors.messages[:five_star_rate]).to eq ['5つ星を入力してください。', '5つ星は1から5の整数のみです。']
      end

      it 'titleが51文字、contentが1001文字入力できないこと' do
        too_length_params = { title: "#{'このホテル' * 6}1", content: "#{'Hotel' * 200}1", five_star_rate: 5 }
        review_form = described_class.new(attributes: too_length_params, user_id: user.id, hotel_id: accepted_hotel.id)
        review_form.valid?
        expect(review_form).to be_invalid
      end

      it 'five_star_rateに小数点がつくと丸められること' do
        bad_five_star_rate = { title: 'このホテル', content: 'よかったです', five_star_rate: 4.9 }
        review_form = described_class.new(attributes: bad_five_star_rate, user_id: user.id, hotel_id: accepted_hotel.id)
        review_form.valid?
        expect(review_form).to be_truthy
      end

      it 'five_star_rateが0のとき失敗すること' do
        bad_five_star_rate = { title: 'このホテル', content: 'よかったです', five_star_rate: 0 }
        review_form = described_class.new(attributes: bad_five_star_rate, user_id: user.id, hotel_id: accepted_hotel.id)
        review_form.valid?
        expect(review_form).to be_invalid
        expect(review_form.errors.messages[:five_star_rate]).to eq ['5つ星は1から5の整数のみです。']
      end
    end
  end

  describe 'models/review_form.rb #default_attributes' do
    let_it_be(:user) { create(:user) }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: user.id) }

    it '値が正常なこと' do
      params = { title: 'よかったです', content: '部屋が綺麗', five_star_rate: 5 }
      review_form = described_class.new(attributes: params, hotel_id: accepted_hotel.id, user_id: user.id)
      allow(review_form).to receive(:default_attributes)
      expect(review_form.title).to eq('よかったです')
    end
  end

  describe 'models/review_form.rb #save' do
    let_it_be(:user) { create(:user) }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: user.id) }

    context '正常に保存ができる場合' do
      it 'paramsの値が正常なこと' do
        params = { title: 'よかったです', content: '部屋が綺麗', five_star_rate: 5 }
        review_form = described_class.new(attributes: params, hotel_id: accepted_hotel.id, user_id: user.id)
        expect { review_form.save }.to change(Review, :count).by(1)
      end

      it '画像をつけるとreview_imagesも更新されること' do
        added_images_params = { title: 'よかったです', content: '部屋が綺麗', five_star_rate: 5, key: 'upload/test', file_url: 'https://example/aws/s3' }
        review_form = described_class.new(attributes: added_images_params, hotel_id: accepted_hotel.id, user_id: user.id)
        pp review_form
        expect { review_form.save }.to change(Review, :count).by(1)
        # expect { review_form.save }.to change(ReviewImage, :count).by(1)
      end
    end

    context '保存ができない場合' do
      it '更新する値が不正なこと' do
        params = { title: '', content: '', five_star_rate: 1 }
        review_form = described_class.new(attributes: params, hotel_id: accepted_hotel.id, user_id: user.id)
        expect(review_form.save).to be_nil
      end
    end
  end
end

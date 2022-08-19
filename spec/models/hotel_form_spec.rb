require 'rails_helper'

RSpec.describe HotelForm, type: :model do
  describe 'models/hotel_form.rb #validation' do
    let_it_be(:user) { create(:user) }

    context '入力値が正常な場合' do
      it 'nameとcontentとhotel_imagesがあれば正常なこと' do
        hotel = described_class.new(name: 'hotelName', content: 'hotelContent', key: 'upload/test', file_url: 'https://example/aws/s3', user_id: user.id)
        expect(hotel).to be_valid
      end

      it 'nameが50文字、contentが2000文字入力できること' do
        hotel = described_class.new(name: 'Hotel' * 10, content: 'Hotel' * 400, key: 'upload/test', file_url: 'https://example/aws/s3', user_id: user.id)
        expect(hotel).to be_valid
      end
    end

    context '入力値が異常な場合' do
      it 'nameとcontentが無ければエラーを返すこと' do
        hotel = described_class.new(name: nil, content: nil, user_id: user.id)
        expect(hotel).to be_invalid
        expect(hotel.errors[:name]).to eq ['を入力してください']
        expect(hotel.errors[:content]).to eq %w[を入力してください は10文字以上で入力してください]
      end

      it 'nameが51文字、contentが2001文字入力できないこと' do
        hotel = described_class.new(name: "#{'Hotel' * 10}1", content: "#{'Hotel' * 400}1", user_id: user.id)
        expect(hotel).to be_invalid
      end
    end
  end

  describe 'models/hotel_form.rb #save' do
    let_it_be(:user) { create(:user) }
    let_it_be(:params) { { name: 'hotelName', content: 'hotelContent', key: 'upload/test', file_url: 'https://example/aws/s3', user_id: user.id } }
    let_it_be(:invalid_images_params) { { name: 'hotelName', content: 'hotelContent', key: '', file_url: '', user_id: user.id } }

    context '正常に保存ができる場合' do
      it 'paramsの値が正常なこと' do
        hotel_form = described_class.new(params)
        expect { hotel_form.save(params) }.to change(Hotel, :count).by(1)
      end
    end

    context '保存ができない場合' do
      it 'RecordInvalidでHotel.create!に失敗すること' do
        expect { Hotel.create!(name: '', content: '', user_id: 0) }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'RecordInvalidでhotel_images.create!に失敗すること' do
        expect { HotelImage.create!(key: '', file_url: '', hotel_id: 0) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end

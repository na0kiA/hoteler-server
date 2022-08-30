require 'rails_helper'

RSpec.describe HotelForm, type: :model do
  describe 'models/hotel_form.rb #validation' do
    let_it_be(:user) { create(:user) }

    context '入力値が正常な場合' do
      it 'nameとcontentとhotel_imagesがあれば正常なこと' do
        params = { name: 'Hotel Kobe', content: 'このホテルは北野坂で最近できたホテルで..', key: 'upload/test', file_url: 'https://example/aws/s3', user_id: user.id}
        hotel_form = described_class.new(attributes: params, user_id: user.id)
        expect(hotel_form).to be_valid
      end

      it 'nameが50文字、contentが2000文字入力できること' do
        max_length_params = { name: 'Hotel' * 10, content: 'Hotel' * 400, key: 'upload/test', file_url: 'https://example/aws/s3', user_id: user.id}
        hotel_form = described_class.new(attributes: max_length_params, user_id: user.id)
        expect(hotel_form).to be_valid
      end
    end

    context '入力値が異常な場合' do
      it 'nameとcontentが無ければエラーを返すこと' do
        nil_params = { name: '', content: '', key: 'upload/test', file_url: 'https://example/aws/s3', user_id: user.id}
        hotel_form = described_class.new(attributes: nil_params, user_id: user.id)
        hotel_form.valid?
        expect(hotel_form).to be_invalid
        expect(hotel_form.errors.messages[:name]).to eq ['ホテル名を入力してください。']
        expect(hotel_form.errors.messages[:content]).to eq ['内容を入力してください。', '内容は10文字以上入力してください。']
      end

      it 'nameが51文字、contentが2001文字入力できないこと' do
        too_length_params = {name: "#{'Hotel' * 10}1", content: "#{'Hotel' * 400}1", key: 'upload/test', file_url: 'https://example/aws/s3', user_id: user.id}
        hotel_form = described_class.new(attributes: too_length_params, user_id: user.id)
        hotel_form.valid?
        expect(hotel_form).to be_invalid
      end
    end
  end

  describe 'models/hotel_form.rb #save' do
    let_it_be(:user) { create(:user) }
    # def save
    #   return if invalid?
  
    #   ActiveRecord::Base.transaction do
    #     hotel.update!(name:, content:)
    #     hotel.hotel_images.update!(key:, file_url:)
    #   end
    # rescue ActiveRecord::RecordInvalid
    #   false
    # end
    context '正常に保存ができる場合' do
      it 'paramsの値が正常でHotelのupdate!できること' do
        params = { name: 'Hotel Kobe', content: 'このホテルは北野坂で最近できたホテルで..', key: 'upload/test', file_url: 'https://example/aws/s3'}
        hotel = Hotel.new
        hotel_form = described_class.new(attributes: params, user_id: user.id, hotel:)
        expect {hotel.update!(name: hotel_form.name, content: hotel_form.content, user_id: user.id)}.to change(Hotel, :count).by(1)
        expect {hotel.hotel_images.create!(key: hotel_form.key, file_url: hotel_form.file_url)}.to change(HotelImage, :count).by(1)
      end

      it "saveができること" do
        hotel = spy('hotel')
        s.save
        expect(s).to have_received(:save)
      end
    end

    context '保存ができない場合' do
      it 'RecordInvalidでhotel.update!に失敗すること' do
        invalid_hotel_params = { name: nil, content: '', key: 'upload/test', file_url: 'https://example/aws/s3'}
        hotel_form = described_class.new(attributes: invalid_hotel_params, user_id: user.id)
        allow(hotel_form).to receive(:default_attributes)
        hotel_form.valid?
        expect(hotel_form.name).to be_nil
      end

      it 'RecordInvalidでhotel.hotel_images.update!に失敗すること' do
        invalid_hotel_images_params = { name: "hotelName", content: 'hotelContent', key: nil, file_url: nil}
        hotel_form = described_class.new(attributes: invalid_hotel_images_params, user_id: user.id)
        hotel = Hotel.new(user_id: user.id)
        allow(hotel_form).to receive(:default_attributes)
        hotel_form.valid?
        expect(hotel.hotel_images.update!(key: '', file_url: '')).to eq([])
      end
    end
  end
end

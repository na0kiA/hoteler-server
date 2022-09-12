require 'rails_helper'
# TODO: saveメソッドのテストが未完成

RSpec.describe HotelForm, type: :model do
  describe 'models/hotel_form.rb #validation' do
    let_it_be(:user) { create(:user) }

    context '入力値が正常な場合' do
      it 'nameとcontentとhotel_imagesがあれば正常なこと' do
        params = { name: 'Hotel Kobe', content: 'このホテルは北野坂で最近できたホテルで..', key: ['upload/test','upload/test2'], user_id: user.id }
        hotel_form = described_class.new(attributes: params, user_id: user.id)
        expect(hotel_form).to be_valid
      end

      it 'nameが50文字、contentが2000文字入力できること' do
        max_length_params = { name: 'Hotel' * 10, content: 'Hotel' * 400, key: ['upload/test','upload/test2'], user_id: user.id }
        hotel_form = described_class.new(attributes: max_length_params, user_id: user.id)
        expect(hotel_form).to be_valid
      end
    end

    context '入力値が異常な場合' do
      it 'nameとcontentが無ければエラーを返すこと' do
        nil_params = { name: '', content: '', key: ['upload/test','upload/test2'], user_id: user.id }
        hotel_form = described_class.new(attributes: nil_params, user_id: user.id)
        hotel_form.valid?
        expect(hotel_form).to be_invalid
        expect(hotel_form.errors.messages[:name]).to eq ['ホテル名を入力してください。']
        expect(hotel_form.errors.messages[:content]).to eq ['内容を入力してください。', '内容は10文字以上入力してください。']
      end

      it 'nameが51文字、contentが2001文字入力できないこと' do
        too_length_params = { name: "#{'Hotel' * 10}1", content: "#{'Hotel' * 400}1", key: ['upload/test','upload/test2'], user_id: user.id }
        hotel_form = described_class.new(attributes: too_length_params, user_id: user.id)
        hotel_form.valid?
        expect(hotel_form).to be_invalid
      end
    end
  end

  describe 'models/hotel_form.rb #save' do

    def params
      attributes.deep_symbolize_keys
    end

    let_it_be(:user) { create(:user) }

    context '正常に保存ができる場合' do
      it 'paramsの値が正常で保存できること' do
        json_params = {"name"=>"神戸北野", "content"=>"最高峰のラグジュアリーホテルをお届けします", "key"=>["key1213", "key4561"], "user_id"=>user.id} 

        hotel_form = HotelForm.new(json_params)
        expect(hotel_form.save(hotel_form.params)).to be true

        params = hotel_form.params

        hotel = Hotel.new(name: params[:name], content: params[:content], user_id: params[:user_id])
        images = JSON.parse(params[:key]).each do |val|
          hotel.hotel_images.build(key: val)
        end
        expect(hotel.name).to eq(params[:name])
        expect(images).to eq(["key1213", "key4561"])
        expect{hotel.save!}.to change(Hotel, :count).by(1).and change(HotelImage, :count).by(2)
      end
    end

    # context '値が不正な場合' do
    #   it "false返ること" do
    #     # json_params = {"name"=>"神戸北野", "content"=>"最高峰のラグジュアリーホテルをお届けします", "key"=>["key1213", "key4561"], "user_id"=>user.id}
    #     params = {:name=>"", :content=>"最高峰のラグジュアリーホテルをお届けします", key: "[\"key1213\", \"key4561\"]", :user_id =>user.id}
    #     expect{}.to be false

    #   end
    # end
  end
end

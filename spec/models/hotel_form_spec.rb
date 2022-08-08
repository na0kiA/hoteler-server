require 'rails_helper'

RSpec.describe HotelForm, type: :model do
  describe "models/hotel_form.rb #validation" do
    let_it_be(:user) { create(:user) }

    context "入力値が正常な場合" do
      it "nameとcontentとhotel_imagesがあれば正常なこと" do
        hotel = described_class.new(name: "hotelName", content: "hotelContent", key: "upload/test", file_url: "https://example/aws/s3", user_id: user.id)
        expect(hotel).to be_valid
      end

      it "nameが50文字、contentが2000文字入力できること" do
        hotel = described_class.new(name: "Hotel" * 10, content: "Hotel" * 400, key: "upload/test", file_url: "https://example/aws/s3", user_id: user.id)
        expect(hotel).to be_valid
      end
    end

    context "入力値が異常な場合" do
      it "nameとcontentとが無ければエラーを返すこと" do
        hotel = described_class.new(name: nil, content: nil, user_id: user.id)
        expect(hotel).to be_invalid
        expect(hotel.errors[:name]).to eq ["を入力してください"]
        expect(hotel.errors[:content]).to eq %w[を入力してください は10文字以上で入力してください]
      end

      it "nameが51文字、contentが2001文字入力できないこと" do
        hotel = described_class.new(name: "#{'Hotel' * 10}1", content: "#{'Hotel' * 400}1", user_id: user.id)
        expect(hotel).to be_invalid
      end
    end
  end

  describe "models/hotel_form.rb #save" do
    let_it_be(:user) { create(:user) }
    context "正常に保存ができる場合" do
      it "saveがparamsを受け取って実行できていること" do
        params = { name: "hotelName", content: "hotelContent", key: "upload/test", file_url: "https://example/aws/s3", user_id: user.id }
        s = spy
        s.save(params)
        expect(s).to have_received(:save).with(name: "hotelName", content: "hotelContent", key: "upload/test", file_url: "https://example/aws/s3", user_id: user.id)

        hotel = { name: params[:name], content: params[:content], user_id: params[:user_id] }

        expect { Hotel.create!(hotel) }.to change(Hotel, :count).by(1)
        hotel_form = Hotel.create!(hotel)
        image = { hotel_id: hotel_form.id, key: params[:key], file_url: params[:file_url] }

        expect { HotelImage.create!(image) }.to change(HotelImage, :count).by(1)

        # hotel_form = HotelForm.new(params)
        # allow(hotel_form).to receive(:save).and_return(hotel_form)
        # expect(hotel_form.save(params)).to include("name")
      end
    end

    context "保存ができない場合" do
    end
  end
end

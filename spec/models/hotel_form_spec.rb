require 'rails_helper'

RSpec.describe HotelForm, type: :model do
  describe "models/hotel_form.rb #validation" do
    let_it_be(:user) { create(:user) }

    # before :each do
    #   @hotel_form = HotelForm.new
    # end

    context "入力値が正常な場合" do
      it "nameとcontentとhotel_imagesがあれば正常なこと" do
        hotel = described_class.new(name: "hotelName", content: "hotelContent", hotel_images: [key: "upload/test", file_url: "https://example/aws/s3"], user_id: user.id)
        expect(hotel).to be_valid
      end

      it "nameが50文字、contentが2000文字入力できること" do
        hotel = described_class.new(name: "Hotel" * 10, content: "Hotel" * 400, hotel_images: [key: "upload/test", file_url: "https://example/aws/s3"], user_id: user.id)
        expect(hotel).to be_valid
      end
    end

    context "入力値が異常な場合" do
      it "nameとcontentとhotel_s3_keyが無ければエラーを返すこと" do
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

  describe "models/hotel_form.rb #params" do
    let_it_be(:user) { create(:user) }

    context "正常に動作する場合" do
      it "受け取ったparamsをシンボルにすること" do
        hotel = described_class.new("name" => "hotelName", "content" => "hotelContent", "hotel_images" => ["key" => "upload/test", "file_url" => "https://example/aws/s3"], "user_id" => user.id)

        expect(hotel.params).to eq(name: "hotelName", content: "hotelContent", hotel_images: [{ key: "upload/test", file_url: "https://example/aws/s3" }], user_id: user.id)
      end
    end
  end
end

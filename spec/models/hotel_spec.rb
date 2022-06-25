require 'rails_helper'

RSpec.describe Hotel, type: :model do
  describe "models/hotel.rb #validation" do
    let!(:user) { create(:user) }
    let!(:hotel_invalid) { described_class.new(name: nil, content: nil) }

    context "入力値が正常な場合" do
      it "nameとcontentがあれば正常なこと" do
        hotel = build(:hotel, user_id: user.id)
        expect(hotel).to be_valid
      end

      it "nameが50文字、contentが2000文字入力できること" do
        hotel = described_class.create(name: "Hotel" * 10, content: "Hotel" * 400, user_id: user.id)
        expect(hotel).to be_valid
      end
    end

    context "入力値が異常な場合" do
      it "nameとcontentが無ければエラーを返すこと" do
        expect(hotel_invalid).to be_invalid
        expect(hotel_invalid.errors[:name]).to eq ["を入力してください"]
        expect(hotel_invalid.errors[:content]).to eq ["を入力してください"]
      end

      it "nameが51文字、contentが2001文字入力できないこと" do
        hotel = described_class.create(name: "#{'Hotel' * 10}1", content: "#{'Hotel' * 400}1", user_id: user.id)
        expect(hotel).to be_invalid
      end
    end
  end
end

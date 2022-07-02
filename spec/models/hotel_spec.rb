require 'rails_helper'

RSpec.describe Hotel, type: :model do
  describe "models/hotel.rb #validation" do
    let_it_be(:user) { create(:user) }

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
        hotel = described_class.create(name: nil, content: nil, user_id: user.id)
        expect(hotel).to be_invalid
        expect(hotel.errors[:name]).to eq ["を入力してください"]
        expect(hotel.errors[:content]).to eq ["を入力してください"]
      end

      it "nameが51文字、contentが2001文字入力できないこと" do
        hotel = described_class.create(name: "#{'Hotel' * 10}1", content: "#{'Hotel' * 400}1", user_id: user.id)
        expect(hotel).to be_invalid
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Hotel, type: :model do
  describe "models/hotel.rb #validation"do 
    let!(:user)  {create(:user)}
    let!(:hotel_invalid)  {Hotel.new(name: nil, content: nil)}

    context "入力値が正常な場合" do
      it "nameとcontentがあれば正常なこと" do
        hotel = build(:hotel, user_id: user.id)
        expect(hotel).to be_valid
      end
    end

    context "入力値が異常な場合" do
      it "nameとcontentが無ければエラーを返すこと" do
        expect(hotel_invalid).to be_invalid
        expect(hotel_invalid.errors[:name]).to eq ["can't be blank"]
        expect(hotel_invalid.errors[:content]).to eq ["can't be blank"]
      end
    end
  end
end
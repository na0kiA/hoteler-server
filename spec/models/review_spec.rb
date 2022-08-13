require 'rails_helper'

RSpec.describe Review, type: :model do
  # def save(params)
  #   hotel = Hotel.accepted.find(params[:hotel_id])
  #   hotel.reviews.create!(title: params[:title], content: params[:content], user_id: params[:user_id])
  # end

  context "saveができる場合" do
    let_it_be(:client_user)  { create(:user) }
    let_it_be(:auth_tokens)  { client_user.create_new_auth_token }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: client_user.id) }

    it "承認済みのホテルのidを受け取っていること" do
      params = { title: "title uploaded", content: "content uploaded", user_id: client_user.id, hotel_id: accepted_hotel.id }
      expect { described_class.save(params) }.to change(described_class, :count).by(1)
    end

    it "承認済みのホテルのidを受け取っていること" do
      hotel = Hotel.find(accepted_hotel.id)
      expect(hotel.id).to eq(accepted_hotel.id)
    end

    it "hotelをreviewと関連付けて作成できること" do
      hotel = Hotel.find(accepted_hotel.id)
      hotel.reviews.create!(title: "title uploaded", content: "content uploaded", user_id: client_user.id, hotel_id: hotel.id)
      expect(hotel.reviews[0][:title]).to eq("title uploaded")
    end

    it "Reviewに新規レコードが作成できていること" do
      hotel = Hotel.find(accepted_hotel.id)
      expect { hotel.reviews.create!(title: "title uploaded", content: "content uploaded", user_id: client_user.id, hotel_id: hotel.id) }.to change(described_class, :count).by(1)
    end
  end

  context "saveができない場合" do
    let_it_be(:client_user) { create(:user) }
    it "未承認のホテルであること" do
      hotel = create(:hotel, user_id: client_user.id)
      hotel.reviews.create!(title: "title uploaded", content: "content uploaded", user_id: client_user.id, hotel_id: hotel.id)
      expect(hotel.reviews[0][:title]).to eq("title uploaded")
    end
  end
end

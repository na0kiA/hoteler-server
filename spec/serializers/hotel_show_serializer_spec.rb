# frozen_string_literal: true

require "rails_helper"

RSpec.describe HotelShowSerializer, type: :serializer do
  describe HotelShowSerializer do
    let_it_be(:user) { create(:user) }

    context "ホテル詳細が取得できる場合" do
      let_it_be(:hotel) { create(:with_five_reviews_and_helpfulnesses, user_id: user.id) }
      let_it_be(:hotel_images) { create_list(:hotel_image, 3, hotel_id: hotel.id) }

      let_it_be(:json_serializer) { HotelShowSerializer.new(hotel).as_json }

      it "acceptedが含まれていること" do
        expect(json_serializer.keys).to include :accepted
      end

      it "hotel_imagesが含めれていること" do
        expect(json_serializer.keys).to include :hotel_images
      end

      it "day_of_the_weekが含めれていないこと" do
        expect(json_serializer.keys).not_to include :day_of_the_week
      end

      it "top_four_reviewsが含めれていること" do
        expect(json_serializer.keys).to include :top_four_reviews
      end
    end

    context "口コミが5個ある場合" do
      let_it_be(:hotel) { create(:with_five_reviews_and_helpfulnesses, user_id: user.id) }
      let_it_be(:hotel_images) { create(:hotel_image, hotel_id: hotel.id) }

      it "口コミは参考になったが多い順に4個までに絞り込まれていること" do
        json_serializer = HotelShowSerializer.new(hotel).as_json
        expect(json_serializer[:top_four_reviews].count).to eq(4)
        expect(json_serializer[:top_four_reviews].first[:helpfulnessesCount]).to eq(5)
        expect(json_serializer[:top_four_reviews].last[:helpfulnessesCount]).to eq(2)
      end
    end

    context "口コミに参考になったが押された場合" do
      let_it_be(:hotel) { create(:completed_profile_hotel, :with_user) }
      let_it_be(:helpfulness) { create(:helpfulness, review: create(:review, hotel:, user:)) }

      it "helpfulnesses_countが1になっていること" do
        json_serializer = HotelShowSerializer.new(hotel).as_json
        expect(json_serializer[:top_four_reviews][0][:helpfulnessesCount]).to eq(1)
      end
    end

    context "口コミが一つもない場合" do
      let_it_be(:hotel) { create(:completed_profile_hotel, user_id: user.id) }
      let_it_be(:hotel_images) { create(:hotel_image, hotel_id: hotel.id) }

      it "何も返さないこと" do
        json_serializer = HotelShowSerializer.new(hotel).as_json
        expect(json_serializer[:top_four_reviews]).to be_nil
      end
    end
  end
end

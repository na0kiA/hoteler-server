# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HotelShowSerializer, type: :serializer do
  describe HotelShowSerializer do
    let_it_be(:user) { create(:user) }
    let_it_be(:hotel) { create(:completed_profile_hotel, :with_a_day_and_service_rates, user_id: user.id) }
    let_it_be(:review) { create(:review, :five_star_rated_review, user_id: user.id, hotel_id: hotel.id) }
    let_it_be(:hotel_images) { create_list(:hotel_image, 3, hotel_id: hotel.id) }

    context 'ホテル詳細が取得できる場合' do
      let_it_be(:json_serializer) { HotelShowSerializer.new(hotel).as_json }

      it 'acceptedが含まれていないこと' do
        expect(json_serializer.keys).not_to include :accepted
      end

      it 'hotel_imagesが含めれていること' do
        expect(json_serializer.keys).to include :hotel_images
      end

      it 'day_of_the_weekが含めれていること' do
        expect(json_serializer.keys).to include :day_of_the_week
      end
      
      it 'top_four_reviewsが含めれていること' do
        expect(json_serializer.keys).to include :top_four_reviews
      end
    end

    context '口コミが5個ある場合' do
      let_it_be(:other_user) { create(:user) }
      let_it_be(:four_review) { create(:review, :four_star_rated_review, user_id: user.id, hotel_id: hotel.id) }
      let_it_be(:three_review) { create(:review, :three_star_rated_review, user_id: user.id, hotel_id: hotel.id) }
      let_it_be(:two_review) { create(:review, :two_star_rated_review, user_id: user.id, hotel_id: hotel.id) }
      let_it_be(:one_review) { create(:review, :one_star_rated_review, user_id: user.id, hotel_id: hotel.id) }

      before do
        create(:helpfulness, review_id: four_review.id, user_id: other_user.id)
        create(:helpfulness, review_id: three_review.id, user_id: other_user.id)
      end

      it '口コミは参考になったが多い順に4個までに絞り込まれていること' do
        json_serializer = HotelShowSerializer.new(hotel).as_json
        p json_serializer
        p Helpfulness.all
        expect(json_serializer[:top_four_reviews].count).to eq(4)
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReviewOfTopPage, type: :model do
  describe 'models/review_of_top_page.rb #extract_top_reviews' do
    let_it_be(:user) { create(:user) }

    context '口コミが5つある場合' do
      let_it_be(:hotel) { create(:with_five_reviews_and_helpfulnesses, user_id: user.id) }

      it '参考になったの多い順に4つ抽出できていること' do
        reviews = described_class.new(reviews_of_a_hotel: hotel.reviews)
        sorted_reviews_id = reviews.extract_top_reviews.pluck(:id)
        most_helped_count = Helpfulness.where(review_id: sorted_reviews_id.first).length
        expect(most_helped_count).to eq(5)
        expect(reviews.extract_top_reviews.length).to eq(4)
      end
    end

    context '参考になったの数が全て0の口コミが5つある場合' do
      let_it_be(:hotel) { create(:completed_profile_hotel, user_id: user.id) }
      let_it_be(:other_user) { create(:user) }
      let_it_be(:review) { create_list(:review, 5, user_id: other_user.id, hotel_id: hotel.id) }

      it 'IDの新しい口コミを4つ抽出できていること' do
        reviews = described_class.new(reviews_of_a_hotel: hotel.reviews)
        sorted_reviews_id = reviews.extract_top_reviews.pluck(:id)
        sort_reviews_id = Review.pluck(:id).sort
        expect(sorted_reviews_id.last).to eq(sort_reviews_id.last)
        expect(sort_reviews_id.first).not_to eq(sorted_reviews_id.first)
      end
    end

    context '口コミが一つの場合' do
      let_it_be(:hotel) { create(:completed_profile_hotel, user_id: user.id) }
      let_it_be(:other_user) { create(:user) }
      let_it_be(:review) { create(:review, user_id: other_user.id, hotel_id: hotel.id) }

      it '口コミを1つ抽出できていること' do
        reviews = described_class.new(reviews_of_a_hotel: hotel.reviews)
        expect(reviews.extract_top_reviews.length).to eq(1)
      end
    end

    context '口コミが一つも無い場合' do
      let_it_be(:hotel) { create(:completed_profile_hotel, user_id: user.id) }
      let_it_be(:other_user) { create(:user) }

      it '空の配列を返すこと' do
        reviews = described_class.new(reviews_of_a_hotel: hotel.reviews)
        expect(reviews.extract_top_reviews.length).to eq(0)
      end
    end
  end
end

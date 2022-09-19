require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'models/review_edit.rb #update_zero_rating' do
    let_it_be(:user) { create(:user) }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: user.id) }
    let_it_be(:review) { create(:review, hotel_id: accepted_hotel.id, user_id: user.id) }

    context '口コミ数が0になった場合' do
      it 'ホテルの評価数と評価率が0になること' do
        expect { Review.update_zero_rating(set_review: review) }.to change { Hotel.where(id: review.hotel_id).pluck(:reviews_count) }.from([1]).to([0])
        expect(Review.update_zero_rating(set_review: review).average_rating).to eq(0.0)
      end
    end

    context '口コミ数が0じゃない場合' do
      let_it_be(:last_review) { create(:review, hotel_id: accepted_hotel.id, user_id: user.id) }

      it 'nilを返すこと' do
        expect(Review.update_zero_rating(set_review: review)).to be_nil
      end
    end
  end
end
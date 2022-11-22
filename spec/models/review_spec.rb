# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'models/review.rb #update_zero_rating' do
    let_it_be(:user) { create(:user) }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: user.id) }
    let_it_be(:review) { create(:review, hotel_id: accepted_hotel.id, user_id: user.id) }

    context '口コミ数が0になった場合' do

      it 'ホテルの評価数が0になること' do
        expect { described_class.destroy(review.id) }.to change { Hotel.find_by(id: accepted_hotel).reviews_count }.from(1).to(0)
      end

      it 'ホテルの評価率が0になること' do
        expect { described_class.destroy(review.id) }.to change { Hotel.find_by(id: accepted_hotel).average_rating }.from(1).to(0)
      end
    end
  end
end

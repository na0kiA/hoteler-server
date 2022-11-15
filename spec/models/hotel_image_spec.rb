# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HotelImage, type: :model do
  describe 'models/hotel_image.rb #save' do
    let_it_be(:user) { create(:user) }

    context '口コミが5つある場合' do
      let_it_be(:hotel) { create(:with_five_reviews_and_helpfulnesses, user_id: user.id) }

      it '参考になったの多い順に4つ抽出できていること' do
      end
    end

    context '参考になったの数が全て0の口コミが5つある場合' do
      let_it_be(:hotel) { create(:completed_profile_hotel, user_id: user.id) }
      let_it_be(:other_user) { create(:user) }
      let_it_be(:review) { create_list(:review, 5, user_id: other_user.id, hotel_id: hotel.id) }

      it 'IDの新しい口コミを4つ抽出できていること' do
      end
    end

    context '口コミが一つの場合' do
      let_it_be(:hotel) { create(:completed_profile_hotel, user_id: user.id) }
      let_it_be(:other_user) { create(:user) }
      let_it_be(:review) { create(:review, user_id: other_user.id, hotel_id: hotel.id) }

      it '口コミを1つ抽出できていること' do
      end
    end

    context '口コミが一つも無い場合' do
      let_it_be(:hotel) { create(:completed_profile_hotel, user_id: user.id) }
      let_it_be(:other_user) { create(:user) }

      it '空の配列を返すこと' do
      end
    end
  end
end

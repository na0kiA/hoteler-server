# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReviewEdit, type: :model do
  describe 'models/review_edit.rb #update' do
    let_it_be(:user) { create(:user) }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: user.id) }
    let_it_be(:review) { create(:review, hotel_id: accepted_hotel.id, user_id: user.id) }

    context '正常に更新ができる場合' do
      it 'paramsが正常なこと' do
        params = {
          'title' => 'よかったです',
          'content' => 'コノホテルはよかったです',
          'five_star_rate' => 3,
          'hotel_id' => accepted_hotel.id,
          'user_id' => user.id
        }
        review_form = ReviewForm.new(params)
        review_edit = described_class.new(params: review_form.to_deep_symbol, set_review: review)
        expect(review_edit.update).to be_truthy
      end

      it 'paramsが更新されていること' do
        params = {
          title: 'よかったです',
          content: 'コノホテルはよかったです',
          five_star_rate: 3,
          hotel_id: accepted_hotel.id,
          user_id: user.id
        }
        review_edit = described_class.new(params:, set_review: review)
        review_edit.instance_variable_get(:@params)
        expect(params[:title]).to eq('よかったです')
        expect(review_edit.send(:extract_unnecessary_key)).to eq([])
        expect(review_edit.update).to be_truthy
      end

      it '画像をつけるとReviewImageも更新されること' do
        include_image_params = {
          'title' => 'よかったです',
          'content' => 'コノホテルはよかったです',
          'five_star_rate' => 3,
          'key' => ['randum/secure/key', 'key19982'],
          'hotel_id' => accepted_hotel.id,
          'user_id' => user.id
        }
        review_form = ReviewForm.new(include_image_params)
        review_edit = described_class.new(params: review_form.to_deep_symbol, set_review: review)
        expect { review_edit.update }.to change(ReviewImage, :count).by(2)
      end

      it 'Hotelのrating_averageが更新されること' do
        params = {
          'title' => 'よかったです',
          'content' => 'コノホテルはよかったです',
          'five_star_rate' => 3,
          'hotel_id' => accepted_hotel.id,
          'user_id' => user.id
        }
        review_form = ReviewForm.new(params)
        review_edit = described_class.new(params: review_form.to_deep_symbol, set_review: review)
        review_edit.update
        expect(Hotel.where(id: accepted_hotel.id).pick(:average_rating).to_i).to eq(3)
      end
    end

    context '値が不正な場合' do
      it 'returnで終了してnilを返すこと' do
        invalid_params = {
          'title' => '',
          'content' => 'コノホテルはよかったです',
          'five_star_rate' => 3,
          'key' => ['randum/secure/key', 'key19982'],
          'hotel_id' => accepted_hotel.id,
          'user_id' => user.id
        }
        review_form = ReviewForm.new(invalid_params)
        review_edit = described_class.new(params: review_form.to_deep_symbol, set_review: review)
        expect(review_edit.update).to be_nil
      end
    end
  end
end

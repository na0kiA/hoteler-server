# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HotelImage, type: :model do
  describe 'models/hotel_image.rb #save' do
    let_it_be(:user) { create(:user) }

    context 'keyが9個ある場合' do
      let_it_be(:hotel) { create(:completed_profile_hotel, user_id: user.id) }

      it '9個保存できること' do
        hotel_images = { key: ['upload/test1', 'upload/test2', 'upload/test3', 'upload/test8', 'upload/test4', 'upload/test5', 'upload/test6', 'upload/test7', 'upload/test9'], hotel_id: hotel.id }
        images = described_class.new(hotel_images)
        expect { images.save }.to change(HotelImage, :count).by(9)
      end
    end

    context 'keyが10個ある場合' do
      let_it_be(:hotel) { create(:completed_profile_hotel, user_id: user.id) }

      it '保存に失敗すること' do
        hotel_images = {
          key: ['upload/test1', 'upload/test2', 'upload/tes3t', 'upload/test8', 'upload/test4', 'upload/test5', 'upload/test6', 'upload/test7', 'upload/test9', 'upload/test10',
                'upload/test11'], hotel_id: hotel.id
        }
        images = described_class.new(hotel_images)
        expect { images.save }.not_to change(HotelImage, :count)
        expect(images.save).to be_nil
      end
    end
  end
end

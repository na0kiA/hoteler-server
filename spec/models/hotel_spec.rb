# frozen_string_literal: true

require "rails_helper"

RSpec.describe Hotel, type: :model do
  describe "models/hotel.rb #create_hotel_facilities" do
    context "ホテルを作成した場合" do
      it "HotelFacilityとDayがコールバックで作成されること" do
        expect { create(:completed_profile_hotel, :with_user) }.to change(HotelFacility, :count).by(1).and change(Day, :count).by(7)
      end
    end
  end
end

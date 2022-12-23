# frozen_string_literal: true

require "rails_helper"

RSpec.describe Hotel, type: :model do
  describe "models/hotel.rb #create_hotel_facilities" do
    context "ホテルを作成した場合" do
      it "HotelFacilityとDayがコールバックで作成されること" do
        expect { create(:completed_profile_hotel, :with_user) }.to change(HotelFacility, :count).by(1).and change(Day, :count).by(7)
      end

      it "休憩と宿泊と特別期間が作成できること" do
        expect { create(:with_service_completed_hotel, :with_user) }.to change(RestRate, :count).by(16).and change(StayRate, :count).by(14).and change(SpecialPeriod, :count).by(3)
      end
    end
  end
end

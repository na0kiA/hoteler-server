# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExtractTodayService, type: :model do
  describe "models/extract_today_service.rb #extract_today_services" do
    let_it_be(:hotel) { create(:with_service_completed_hotel, :with_user) }

    context "特別期間じゃない場合" do
      before do
        travel_to Time.zone.local(2022, 10, 13, 1, 0, 0)
      end

      it "ホテルのその日の休憩料金と宿泊料金を取得できること" do
        hotel_and_services = ExtractTodayService.new(hotels: Hotel.accepted).extract_today_services
        expect(hotel_and_services.length).to eq(2)
        expect(hotel_and_services.first.day.day).to eq("月曜から木曜")
        expect(hotel_and_services.first.rate).to eq(4980)
      end
    end

    context "特別期間の場合" do
      before do
        travel_to Time.zone.local(2023, 12, 25, 19, 0, 0)
      end

      it "ホテルの特別期間の休憩料金と宿泊料金を取得できること" do
        hotel_and_services = ExtractTodayService.new(hotels: Hotel.accepted).extract_today_services
        expect(hotel_and_services.second.day.day).to eq("特別期間")
        expect(hotel_and_services.second.rate).to eq(12980)
      end
    end

    context "特別期間最終日の場合" do
      before do
        travel_to Time.zone.local(2024, 1, 5, 0, 0, 0)
      end

      it "通常期間の宿泊料金を取得できること" do
        hotel_and_services = ExtractTodayService.new(hotels: Hotel.accepted).extract_today_services
        expect(hotel_and_services.second.day.day).to eq("金曜")
        expect(hotel_and_services.second.rate).to eq(3980)
      end

      it "特別期間の休憩料金を取得できること" do
        hotel_and_services = ExtractTodayService.new(hotels: Hotel.accepted).extract_today_services
        expect(hotel_and_services.first.day.day).to eq("特別期間")
        expect(hotel_and_services.first.rate).to eq(5980)
      end
    end
  end
end

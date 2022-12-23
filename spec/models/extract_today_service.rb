# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExtractTodayService, type: :model do
  describe "models/extract_today_service.rb #extract_today_services" do
    context "ホテルにサービスが有る場合" do
      # let_it_be(:hotels) { create_list(:with_service_completed_hotel, 3, :with_user) }

      it "ホテルのその日の休憩料金を取得できること" do
        create_list(:with_service_completed_hotel, 3, :with_user)
        hotel_and_services = ExtractTodayService.new(hotels: Hotel.preload(:hotel_images).accepted).extract_today_services
        expect(hotel_and_services).to eq("s")
      end
    end
  end
end

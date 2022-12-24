# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExtractTodayService, type: :model do
  describe "models/extract_today_service.rb #extract_today_services" do
    context "ホテルにサービスが有る場合" do
      let_it_be(:hotels) { create_list(:with_service_completed_hotel, 3, :with_user) }

      it "ホテルのその日の休憩料金を取得できること" do
        hotel_and_services = ExtractTodayService.new(hotels: Hotel.eager_load(:hotel_images, :days, :rest_rates, :stay_rates).accepted).extract_today_services
        expect(hotel_and_services).to eq(hotels.first)
      end
    end
  end
end

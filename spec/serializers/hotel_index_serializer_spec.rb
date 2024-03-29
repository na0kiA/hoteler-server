# frozen_string_literal: true

require "rails_helper"

RSpec.describe HotelIndexSerializer, type: :serializer do
  describe HotelIndexSerializer do
    let_it_be(:user) { create(:user) }
    let_it_be(:hotel) { create(:completed_profile_hotel, :with_days_and_service_rates, user_id: user.id) }
    let_it_be(:hotel_images) { create_list(:hotel_image, 3, hotel_id: hotel.id) }

    context "ホテル一覧が取得できる場合" do
      let_it_be(:json_serializer) { HotelIndexSerializer.new(hotel).as_json }

      it "acceptedが含まれていないこと" do
        expect(json_serializer.keys).not_to include :accepted
      end

      it "rest_ratesが含めれていること" do
        expect(json_serializer.keys).to include :rest_rates
      end

      it "stay_ratesが含めれていること" do
        expect(json_serializer.keys).to include :stay_rates
      end

      it "hotel_imagesが含めれていること" do
        expect(json_serializer.keys).to include :hotel_images
      end
    end

    context "同じ料金の休憩プランがある場合" do
      let_it_be(:same_rest_rate_plan) { create(:rest_rate, :morning_rest_rate, day_id: hotel.days.ids[0]) }

      before do
        travel_to Time.zone.local(2022, 10, 13, 4, 0, 0)
      end

      it "現在時刻から終了時刻までが一番長い休憩プランが返ること" do
        services = ExtractTodayService.new(hotels: Hotel.accepted).extract_today_services
        json_serializer = HotelIndexSerializer.new(hotel, services:).as_json
        expect(json_serializer[:rest_rates][:plan]).to eq("早朝休憩90分")
      end
    end

    context "今日が木曜日で、時刻が23時59分の場合" do
      before do
        travel_to Time.zone.local(2022, 10, 13, 23, 59, 0)
      end

      it "月曜から木曜にだけある休憩60分が表示されること" do
        services = ExtractTodayService.new(hotels: Hotel.accepted).extract_today_services
        json_serializer = HotelIndexSerializer.new(hotel, services:).as_json
        expect(json_serializer[:rest_rates][:plan]).to eq("休憩60分")
      end

      it "月曜から木曜にだけある宿泊2部が表示されること" do
        services = ExtractTodayService.new(hotels: Hotel.accepted).extract_today_services
        json_serializer = HotelIndexSerializer.new(hotel, services:).as_json
        expect(json_serializer[:stay_rates][:plan]).to eq("宿泊2部")
      end

      it "深夜休憩が表示されないこと" do
        services = ExtractTodayService.new(hotels: Hotel.accepted).extract_today_services
        json_serializer = HotelIndexSerializer.new(hotel, services:).as_json
        expect(json_serializer[:rest_rates][:plan]).not_to eq("深夜休憩90分")
      end
    end

    context "今日が木曜日で、時刻が0時00分の場合" do
      before do
        travel_to Time.zone.local(2022, 10, 13, 0, 0, 0)
      end

      it "深夜料金が表示されること" do
        services = ExtractTodayService.new(hotels: Hotel.accepted).extract_today_services
        json_serializer = HotelIndexSerializer.new(hotel, services:).as_json
        expect(json_serializer[:rest_rates][:plan]).to eq("深夜休憩90分")
      end

      it "素泊まりプランが表示されること" do
        services = ExtractTodayService.new(hotels: Hotel.accepted).extract_today_services
        json_serializer = HotelIndexSerializer.new(hotel, services:).as_json
        expect(json_serializer[:stay_rates][:plan]).to eq("素泊まり")
      end

      it "通常の休憩料金が表示されないこと" do
        services = ExtractTodayService.new(hotels: Hotel.accepted).extract_today_services
        json_serializer = HotelIndexSerializer.new(hotel, services:).as_json
        expect(json_serializer[:rest_rates][:plan]).not_to eq("休憩90分")
      end
    end

    context "今日が木曜日で、時刻が5時01分の場合" do
      before do
        travel_to Time.zone.local(2022, 10, 13, 5, 0o1, 0)
      end

      it "営業時間外であること" do
        services = ExtractTodayService.new(hotels: Hotel.accepted).extract_today_services
        json_serializer = HotelIndexSerializer.new(hotel, services:).as_json
        expect(json_serializer[:rest_rates]).to eq("休憩は営業時間外です")
      end
    end

    context "今日が月曜日の13時の場合" do
      before do
        travel_to Time.zone.local(2022, 11, 14, 13, 0, 0)
      end

      it "宿泊1部が表示されること" do
        services = ExtractTodayService.new(hotels: Hotel.accepted).extract_today_services
        json_serializer = HotelIndexSerializer.new(hotel, services:).as_json
        expect(json_serializer[:stay_rates][:plan]).to eq("宿泊1部")
        expect(json_serializer[:stay_rates][:rate]).to eq(5980)
      end
    end

    context "今日が金曜日で、時刻が5時59分の場合" do
      before do
        travel_to Time.zone.local(2022, 11, 4, 5, 59, 0)
      end

      it "営業時間外であること" do
        services = ExtractTodayService.new(hotels: Hotel.accepted).extract_today_services
        json_serializer = HotelIndexSerializer.new(hotel, services:).as_json
        expect(json_serializer[:rest_rates]).to eq("休憩は営業時間外です")
      end

      it "金曜が表示されること" do
        services = ExtractTodayService.new(hotels: Hotel.accepted).extract_today_services
        json_serializer = HotelIndexSerializer.new(hotel, services:).as_json
        expect(json_serializer[:stay_rates][:day]).to eq("金曜")
      end
    end

    context "今日が特別期間の最終日前日朝6時の場合" do
      before do
        travel_to Time.zone.local(2023, 8, 14, 6, 0, 0)
      end

      it "特別料金が表示されること" do
        services = ExtractTodayService.new(hotels: Hotel.accepted).extract_today_services
        json_serializer = HotelIndexSerializer.new(hotel, services:).as_json
        expect(json_serializer[:rest_rates][:rate]).to eq(5980)
        expect(json_serializer[:stay_rates][:rate]).to eq(12_980)
      end

      it "通常の休憩料金が表示されないこと" do
        services = ExtractTodayService.new(hotels: Hotel.accepted).extract_today_services
        json_serializer = HotelIndexSerializer.new(hotel, services:).as_json
        expect(json_serializer[:rest_rates][:rate]).not_to eq(3980)
      end
    end

    context "今日が特別期間の最終日朝6時の場合" do
      before do
        travel_to Time.zone.local(2023, 8, 15, 6, 0, 0)
      end

      it "休憩料金は特別料金が表示されること" do
        services = ExtractTodayService.new(hotels: Hotel.accepted).extract_today_services
        json_serializer = HotelIndexSerializer.new(hotel, services:).as_json
        expect(json_serializer[:rest_rates][:rate]).to eq(5980)
      end

      it "日をまたぐ宿泊などのサービスは通常料金が表示されること" do
        services = ExtractTodayService.new(hotels: Hotel.accepted).extract_today_services
        json_serializer = HotelIndexSerializer.new(hotel, services:).as_json
        expect(json_serializer[:stay_rates][:rate]).to eq(5980)
      end
    end

    context "今日が祝日で明日が平日の朝6時の場合" do
      before do
        travel_to Time.zone.local(2022, 11, 3, 13, 0, 0)
      end

      it "祝日料金が表示されること" do
        services = ExtractTodayService.new(hotels: Hotel.accepted).extract_today_services
        json_serializer = HotelIndexSerializer.new(hotel, services:).as_json
        expect(json_serializer[:rest_rates][:rate]).to eq(5980)
      end

      it "宿泊は平日料金が表示されること" do
        services = ExtractTodayService.new(hotels: Hotel.accepted).extract_today_services
        json_serializer = HotelIndexSerializer.new(hotel, services:).as_json
        expect(json_serializer[:stay_rates][:rate]).to eq(5980)
      end

      it "通常の休憩料金が表示されないこと" do
        services = ExtractTodayService.new(hotels: Hotel.accepted).extract_today_services
        json_serializer = HotelIndexSerializer.new(hotel, services:).as_json
        expect(json_serializer[:rest_rates][:rate]).not_to eq(3980)
      end
    end

    context "今日が祝前日の13時の場合" do
      before do
        travel_to Time.zone.local(2022, 11, 2, 13, 0, 0)
      end

      it "祝前日料金が表示されること" do
        services = ExtractTodayService.new(hotels: Hotel.accepted).extract_today_services
        json_serializer = HotelIndexSerializer.new(hotel, services:).as_json
        expect(json_serializer[:stay_rates][:plan]).to eq("宿泊1部")
        expect(json_serializer[:stay_rates][:rate]).to eq(12_980)
        expect(json_serializer[:rest_rates][:plan]).to eq("休憩90分")
        expect(json_serializer[:rest_rates][:rate]).to eq(5980)
      end
    end

    context "今日が土曜の朝6時の場合" do
      before do
        travel_to Time.zone.local(2022, 11, 5, 6, 0, 0)
      end

      it "宿泊料金は土曜の宿泊一部が表示されること" do
        services = ExtractTodayService.new(hotels: Hotel.accepted).extract_today_services
        json_serializer = HotelIndexSerializer.new(hotel, services:).as_json
        expect(json_serializer[:stay_rates][:plan]).to eq("宿泊1部")
      end

      it "通常の休憩料金が表示されないこと" do
        services = ExtractTodayService.new(hotels: Hotel.accepted).extract_today_services
        json_serializer = HotelIndexSerializer.new(hotel, services:).as_json
        expect(json_serializer[:rest_rates][:rate]).not_to eq(3980)
      end
    end
  end
end

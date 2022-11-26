# frozen_string_literal: true

require "rails_helper"

RSpec.describe SpecialPeriod, type: :model do
  describe "SpecialPeriod#check_that_today_is_a_special_period" do
    let_it_be(:user) { create(:user) }
    let_it_be(:hotel) { create(:completed_profile_hotel, :with_days, user:) }

    context "今日が特別期間の場合" do
      before do
        travel_to Time.zone.local(2023, 12, 25, 0, 0, 0)
      end

      it "trueが返ること" do
        expect(described_class.check_that_today_is_a_special_period?(hotel:)).to be(true)
      end
    end

    context "今日が特別期間最終日の場合" do
      before do
        travel_to Time.zone.local(2024, 1, 5, 23, 59, 0)
      end

      it "trueが返ること" do
        expect(described_class.check_that_today_is_a_special_period?(hotel:)).to be(true)
      end
    end

    context "今日が特別期間じゃない場合" do
      before do
        travel_to Time.zone.local(2023, 12, 2, 0, 0, 0)
      end

      it "falseが返ること" do
        expect(described_class.check_that_today_is_a_special_period?(hotel:)).to be(false)
      end
    end

    context "2022年の特別期間の日付は2025年に適用されない場合" do
      before do
        travel_to Time.zone.local(2025, 12, 25, 0, 0, 0)
      end

      it "falseが返ること" do
        expect(described_class.check_that_today_is_a_special_period?(hotel:)).to be(false)
      end
    end
  end

  describe "SpecialPeriod#check_that_today_is_a_last_day_of_special_periods" do
    let_it_be(:user) { create(:user) }
    let_it_be(:hotel) { create(:completed_profile_hotel, :with_days, user:) }

    context "今日が特別期間最終日の場合" do
      before do
        travel_to Time.zone.local(2024, 1, 5, 0, 0, 0)
      end

      it "trueが返ること" do
        expect(described_class.check_that_today_is_a_last_day_of_special_periods?(hotel:)).to be(true)
      end
    end

    context "今日が特別期間最終日前日の場合" do
      before do
        travel_to Time.zone.local(2024, 1, 5, 23, 59, 0)
      end

      it "falseが返ること" do
        expect(described_class.check_that_today_is_a_last_day_of_special_periods?(hotel:)).to be(true)
      end
    end
  end
end

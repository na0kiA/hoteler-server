require 'rails_helper'

RSpec.describe "V1::Filters", type: :request do
  describe "GET v1_filters_path - v1/filter_controller#index" do
    context "安い順に絞り込む場合" do
      let_it_be(:cheap_hotel) { create(:completed_profile_hotel, :with_days_and_service_rates, :with_user) }
      let_it_be(:expensive_hotel) { create(:completed_profile_hotel, :with_days_and_expensive_service_rates, :with_user) }

      before do
        travel_to Time.zone.local(2022, 12, 12, 12, 0, 0)
      end

      it "ホテルが安い順に並び替えられること" do
        get v1_filters_path, params: { sort: "lower_rest" }
        p symbolized_body(response)
        expect(symbolized_body(response)[0][:rest_rates][0][:rate]).to eq(3280)
        expect(symbolized_body(response)[1][:rest_rates][0][:rate]).to eq(4280)
      end
    end
  end
end

require 'rails_helper'

RSpec.describe HotelProfile, type: :model do
  describe 'models/hotel_form.rb #update' do
    let_it_be(:user) { create(:user) }
    let_it_be(:accepted_hotel) { create(:accepted_hotel, user_id: user.id) }

    context '正常に更新ができる場合' do
      it 'paramsの値が更新されること' do
        params = {:name=>"神戸北野", :content=>"最高峰のラグジュアリーホテルをお届けします", :key=>"[\"key1213\", \"key4561\"]", :user_id=>user.id}

        hotel_profile = HotelProfile.new(params: params, set_hotel: accepted_hotel)
        hotel_profile.instance_variable_get('@params')
        expect(params[:name]).to eq("神戸北野")
        expect(hotel_profile.update).to eq(0)
        expect(hotel_profile.send(:update_hotel)[:name]).to eq("神戸北野")
      end
    end

    # context '値が不正な場合' do
    #   it "false返ること" do
    #     params = {:name=>"", :content=>"最高峰のラグジュアリーホテルをお届けします", :key=>"[\"key1213\", \"key4561\"]", :user_id=>user.id}

    #     hotel_profile = HotelProfile.new(params: params, set_hotel: accepted_hotel)
    #     hotel_profile.instance_variable_get('@params')
    #     expect(params[:name]).to eq(nil)
    #     expect(hotel_profile.update).to eq(0)
    #     expect(hotel_profile.send(:update_hotel)[:name]).to eq("")
    #     expect{hotel_profile.send(:update_hotel)}.to raise_error(ActiveRecord::RecordInvalid)
    #   end
    # end
  end
end

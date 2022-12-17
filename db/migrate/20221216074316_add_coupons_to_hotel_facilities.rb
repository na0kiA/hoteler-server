class AddCouponsToHotelFacilities < ActiveRecord::Migration[7.0]
  def change
    add_column :hotel_facilities, :coupon_enabled, :boolean, default: :false, null: :false
  end
end

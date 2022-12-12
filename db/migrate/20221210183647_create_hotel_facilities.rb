class CreateHotelFacilities < ActiveRecord::Migration[7.0]
  def change
    create_table :hotel_facilities, id: false do |t|
      t.references :hotel, null: false, foreign_key: true, primary_key: true
      t.boolean :parking_enabled, default: false, null: false
      t.boolean :triple_rooms_enabled, default: false, null: false
      t.boolean :secret_payment_enabled, default: false, null: false
      t.boolean :credit_card_enabled, default: false, null: false
      t.boolean :phone_reservation_enabled, default: false, null: false
      t.boolean :net_reservation_enabled, default: false, null: false
      t.boolean :cooking_enabled, default: false, null: false
      t.boolean :breakfast_enabled, default: false, null: false
      t.boolean :wifi_enabled, default: false, null: false

      t.timestamps
    end
  end
end

class CreateHotelFacilities < ActiveRecord::Migration[7.0]
  def change
    create_table :hotel_facilities, id: false do |t|
      t.references :hotel, null: false, foreign_key: true, primary_key: true
      t.boolean :parking, default: false, null: false
      t.boolean :more_than_3_people, default: false, null: false
      t.boolean :secret_payment, default: false, null: false
      t.boolean :credit, default: false, null: false
      t.boolean :phone_reservation, default: false, null: false
      t.boolean :net_reservation, default: false, null: false
      t.boolean :cooking, default: false, null: false
      t.boolean :morning, default: false, null: false

      t.timestamps
    end
  end
end

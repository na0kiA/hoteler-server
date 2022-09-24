class CreateHotelDailyRate < ActiveRecord::Migration[7.0]
  def change
    create_table :hotel_daily_rates do |t|
      t.references :hotel, foreign_key: true, null: false
      t.integer :day, default: 0
      t.string :rest, default: ""
      t.integer :lodging_rate
      t.time :first_lodging_time
      t.time :last_lodging_time

      t.timestamps
    end
  end
end

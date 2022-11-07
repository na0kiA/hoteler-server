class CreateStayRates < ActiveRecord::Migration[7.0]
  def change
    create_table :stay_rates do |t|
      t.references :day, foreign_key: true, null: false
      t.string :plan, default: '', null: false
      t.integer :rate, default: 0, null: false
      t.time :start_time, default: 0, null: false
      t.time :end_time, default: 0, null: false

      t.timestamps
    end
  end
end

class CreateRestRates < ActiveRecord::Migration[7.0]
  def change
    create_table :rest_rates do |t|
      t.references :day, foreign_key: true, null: false
      t.string :plan, default: '', null: false
      t.integer :rate, default: 0, null: false
      t.time :first_time, default: 0, null: false
      t.time :last_time, default: 0, null: false

      t.timestamps
    end
  end
end

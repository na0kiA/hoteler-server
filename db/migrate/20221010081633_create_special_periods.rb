class CreateSpecialPeriods < ActiveRecord::Migration[7.0]
  def change
    create_table :special_periods do |t|
      t.references :day, foreign_key: true, null: false
      t.integer :period, default: 0, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
  
      t.timestamps
    end
  end
end

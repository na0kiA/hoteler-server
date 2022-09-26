class CreateDays < ActiveRecord::Migration[7.0]
  def change
    create_table :days do |t|
      t.references :hotel, foreign_key: true, null: false
      t.string :day, default: '', null: false

      t.timestamps
    end
  end
end

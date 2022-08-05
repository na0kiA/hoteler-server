class CreateHotelImages < ActiveRecord::Migration[7.0]
  def change
    create_table :hotel_images do |t|
      t.references :hotel, index: true, foreign_key: true
      t.string :key, null: false
      t.string :file_url, null: false

      t.timestamps
    end
    add_index :hotel_images, [:key, :file_url], unique: true 
  end
end

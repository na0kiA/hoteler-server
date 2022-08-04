class CreateHotelImages < ActiveRecord::Migration[7.0]
  def change
    create_table :hotel_images do |t|
      t.string :hotel_id
      t.string :key
      t.string :file_url

      t.timestamps
    end
  end
end

class DeleteKeyUniqueFromHotelImages < ActiveRecord::Migration[7.0]
  def up
    remove_index :hotel_images, :key
    # add_index :hotel_images, :key
  end

  def down
    # remove_index :hotel_images, :key
    add_index :hotel_images, :key, unique: true
  end
end

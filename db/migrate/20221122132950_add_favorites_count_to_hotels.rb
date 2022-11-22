class AddFavoritesCountToHotels < ActiveRecord::Migration[7.0]
  def self.up
    add_column :hotels, :favorites_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :hotels, :favorites_count
  end
end

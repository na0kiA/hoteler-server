class AddFullToHotels < ActiveRecord::Migration[7.0]
  def change
    add_column :hotels, :full, :boolean, default: false, null: false
  end
end

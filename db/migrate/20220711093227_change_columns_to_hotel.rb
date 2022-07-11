class ChangeColumnsToHotel < ActiveRecord::Migration[7.0]
  def up
    add_reference :hotels, :image, foreign_key: true
    change_column :hotels, :image_id, :bigint, null: false
  end

  def down
    change_column :hotels, :image, :string, null: false
  end
end

class ChangeColumnsToHotel < ActiveRecord::Migration[7.0]
  def up
    add_reference :hotels, :image, foreign_key: true
  end

  def down
    # change_column :hotels, :image, :string, null: false
    remove_column :hotels, :image, :string
    remove_column :hotels, :image_id, :bigint
  end
end

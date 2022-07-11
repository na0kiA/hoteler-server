class ChangeColumnsToUser < ActiveRecord::Migration[7.0]
  def up
    add_reference :users, :image, foreign_key: true
    change_column :users, :image_id, null: false
  end

  def down
    remove_reference :users, :image
    rename_column :users, :image_id, :image
  end
end

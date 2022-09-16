class ChangeNullBeTrueToKeyAndFileUrl < ActiveRecord::Migration[7.0]
  def up
    change_column_null(:review_images, :key, true)
    change_column_null(:review_images, :file_url, true)
  end

  def down
    change_column(:review_images, :key, :string, null: false)
    change_column(:review_images, :file_url, :string, null: false)
  end
end

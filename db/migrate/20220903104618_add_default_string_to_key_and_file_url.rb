class AddDefaultStringToKeyAndFileUrl < ActiveRecord::Migration[7.0]
  def up
    change_column(:review_images, :key, :string, null: false, default: '')
    change_column(:review_images, :file_url, :string, null: false, default: '')
  end

  def down
    change_column(:review_images, :key, :string, null: false)
    change_column(:review_images, :file_url, :string, null: false)
  end
end

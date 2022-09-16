class RemoveFileUrlFromHotelImageAndReviewImage < ActiveRecord::Migration[7.0]
  def up
    remove_column :hotel_images, :file_url
    remove_column :review_images, :file_url
  end

  def down
    add_column :hotel_images, :file_url, :string, default: '', null: false
    add_column :review_images, :file_url, :string, default: ''
  end
end

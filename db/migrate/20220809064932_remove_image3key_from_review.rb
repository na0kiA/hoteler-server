class RemoveImage3keyFromReview < ActiveRecord::Migration[7.0]
  def up
    remove_column :reviews, :image_s3_key, :string
  end

  def down
    add_column :reviews, :image_s3_key, :string
  end
end

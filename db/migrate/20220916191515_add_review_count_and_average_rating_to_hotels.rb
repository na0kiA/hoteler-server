class AddReviewCountAndAverageRatingToHotels < ActiveRecord::Migration[7.0]
  def change
    add_column :hotels, :reviews_count, :integer, default: 0, null: false
    add_column :hotels, :average_rating, :decimal, default: 0, null: false, precision: 2, scale: 1
  end
end

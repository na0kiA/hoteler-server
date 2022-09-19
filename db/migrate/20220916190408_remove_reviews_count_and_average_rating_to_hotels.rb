class RemoveReviewsCountAndAverageRatingToHotels < ActiveRecord::Migration[7.0]
  def change
    remove_column :hotels, :reviews_count, :integer, default: 0, null: false
    remove_column :hotels, :average_rating, :decimal, default: 0, null: false, precision: 2, scale: 1
  end
end

class RenameTableHelpfulReviewsToHelpfulnesses < ActiveRecord::Migration[7.0]
  def change
    rename_table :helpful_reviews, :helpfulnesses
  end
end

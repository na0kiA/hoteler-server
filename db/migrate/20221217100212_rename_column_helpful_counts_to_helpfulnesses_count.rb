class RenameColumnHelpfulCountsToHelpfulnessesCount < ActiveRecord::Migration[7.0]
  def change
    rename_column :reviews, :helpful_counts, :helpfulnesses_count
  end
end

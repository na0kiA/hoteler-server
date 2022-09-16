class ChangeColumnHelpfulCountsToFiveStarRate < ActiveRecord::Migration[7.0]
  def change
    add_column :reviews, :five_star_rate, :decimal, default: 0, precision: 2, scale: 1
  end
end

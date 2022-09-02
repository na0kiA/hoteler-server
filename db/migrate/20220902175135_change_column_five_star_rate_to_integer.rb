class ChangeColumnFiveStarRateToInteger < ActiveRecord::Migration[7.0]
  def up
    change_column(:reviews, :five_star_rate, :integer, default: 0)
  end

  def down
    change_column(:reviews, :five_star_rate, :decimal, default: 0, precision: 2, scale: 1)
  end
end

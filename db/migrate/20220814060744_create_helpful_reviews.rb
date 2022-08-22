class CreateHelpfulReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :helpful_reviews do |t|
      t.references :review, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
      t.index [:review_id, :user_id], unique: true
    end
  end
end

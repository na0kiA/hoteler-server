class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.references :user, foreign_key: true
      t.references :hotel, foreign_key: true
      t.string :title, null: false
      t.text :content, null: false
      t.string :image_s3_key
      t.integer :helpful_counts, default: 0
      t.timestamps
    end
  end
end

class DropTableReviewImages < ActiveRecord::Migration[7.0]
  def up
    drop_table :review_images do |t|
      t.references :review, index: true, foreign_key: true
      t.string :key

      t.timestamps
    end
  end

  def down
    create_table :review_images do |t|
      t.references :review, index: true, foreign_key: true
      t.string :key

      t.timestamps
    end
    add_index :review_images, [:key], unique: true
  end

end

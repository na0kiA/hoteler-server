class DropTableImages < ActiveRecord::Migration[7.0]
  def up
    drop_table :images
  end

  def down
    create_table :images do |t|
      t.string :hotel_s3_key
      t.string :user_s3_key
      t.references :user, foreign_key: true
      t.references :hotel, foreign_key: true
      t.timestamps
    end
  end
end
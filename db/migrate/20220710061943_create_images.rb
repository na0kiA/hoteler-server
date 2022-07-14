class CreateImages < ActiveRecord::Migration[7.0]
  def change
    create_table :images do |t|
      t.string :hotel_s3_key, null: false
      t.string :user_s3_key, null: false

      t.timestamps
    end
  end
end

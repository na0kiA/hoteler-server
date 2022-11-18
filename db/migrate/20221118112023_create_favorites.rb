class CreateFavorites < ActiveRecord::Migration[7.0]
  def change
    create_table :favorites do |t|
      t.references :user, foreign_key: true, null: false, index: false
      t.references :hotel, foreign_key: true, null: false, index: true
      t.timestamps
    end

    add_index :favorites, [:user_id, :hotel_id], unique: true
  end
end

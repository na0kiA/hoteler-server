class CreateHotels < ActiveRecord::Migration[7.0]
  def change
    create_table :hotels do |t|
      t.references :user, foreign_key: true
      t.string :name, null: false
      t.text :content, null: false
      t.string :image
      t.boolean :accepted, default: false, null: false
      t.timestamps
    end
  end
end

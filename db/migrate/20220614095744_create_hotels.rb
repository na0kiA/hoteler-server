class CreateHotels < ActiveRecord::Migration[7.0]
  def change
    create_table :hotels do |t|
      t.belongs_to :user, foreign_key: true
      t.string :name, null: false, pre
      t.timestamps  
    end
  end
end

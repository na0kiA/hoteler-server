class DropTablePosts < ActiveRecord::Migration[7.0]
  def change
    drop_table :posts do |t|
      t.string "title"
      t.text "body"

      t.timestamps
    end
  end
end

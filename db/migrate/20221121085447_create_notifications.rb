class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.integer :kind, null: false, default: 0
      t.references :user, foreign_key:{ to_table: :users }, null: false
      t.references :sender, foreign_key:{ to_table: :users }, null: false
      t.string :message, default: '', null: false
      t.boolean :read, default: false, null: false

      t.timestamps
    end
  end
end

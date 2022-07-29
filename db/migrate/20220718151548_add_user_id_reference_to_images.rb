class AddUserIdReferenceToImages < ActiveRecord::Migration[7.0]
  def up
    add_reference :images, :user, foreign_key: true
  end

  def down
    remove_reference :images, :user
  end
end

class RemoveReferenceImagesFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_reference :users, :image, foreign_key: true, index: true
  end
end

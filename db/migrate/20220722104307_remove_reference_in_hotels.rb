class RemoveReferenceInHotels < ActiveRecord::Migration[7.0]
  def change
    remove_reference :hotels, :image
  end
end

class AddHotelIdReferenceInImages < ActiveRecord::Migration[7.0]
  def up
    add_reference :images, :hotel, foreign_key: true
  end

  def down
    remove_reference :images, :hotel
  end
end

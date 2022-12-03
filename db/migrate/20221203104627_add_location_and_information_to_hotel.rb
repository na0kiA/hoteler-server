class AddLocationAndInformationToHotel < ActiveRecord::Migration[7.0]
  def change
    add_column :hotels, :prefecture, :string, default: "", null: false
    add_column :hotels, :city, :string, default: "", null: false
    add_column :hotels, :postal_code, :string, default: "", null: false
    add_column :hotels, :street_adress, :string, default: "", null: false
    add_column :hotels, :phone_number, :string, default: "", null: false
    add_column :hotels, :company, :string, default: "", null: false

    add_index :hotels, [:city, :street_adress]
  end
end

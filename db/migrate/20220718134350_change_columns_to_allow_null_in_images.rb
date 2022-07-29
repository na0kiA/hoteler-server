class ChangeColumnsToAllowNullInImages < ActiveRecord::Migration[7.0]
  def up
    change_table :images, bulk: true do |t|
      t.change_null(:hotel_s3_key, true)
      t.change_null(:user_s3_key, true)
    end
  end

  def down
    change_table :images, bulk: true do |t|
      t.change_null(:hotel_s3_key, false)
      t.change_null(:user_s3_key, false)
    end
  end
end

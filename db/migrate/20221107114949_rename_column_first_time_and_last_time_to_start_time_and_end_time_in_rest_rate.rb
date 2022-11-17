class RenameColumnFirstTimeAndLastTimeToStartTimeAndEndTimeInRestRate < ActiveRecord::Migration[7.0]
  def change
    rename_column :rest_rates, :first_time, :start_time
    rename_column :rest_rates, :last_time, :end_time
  end
end

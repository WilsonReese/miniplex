class AddCloseTimeToLocations < ActiveRecord::Migration[6.0]
  def change
    add_column :locations, :close_time, :time
  end
end

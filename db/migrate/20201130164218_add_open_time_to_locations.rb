class AddOpenTimeToLocations < ActiveRecord::Migration[6.0]
  def change
    add_column :locations, :open_time, :time
  end
end

class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.string :street_address
      t.string :location_name

      t.timestamps
    end
  end
end

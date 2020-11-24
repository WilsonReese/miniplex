class CreateTheaters < ActiveRecord::Migration[6.0]
  def change
    create_table :theaters do |t|
      t.integer :seats_in_theater
      t.integer :location_id
      t.float :turnover_time

      t.timestamps
    end
  end
end

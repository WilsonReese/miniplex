class CreateGroupReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :group_reservations do |t|
      t.string :reservation_status
      t.date :reservation_date
      t.time :reservation_time
      t.float :reservation_duration
      t.integer :number_of_tickets
      t.integer :movie_id
      t.integer :theater_id

      t.timestamps
    end
  end
end

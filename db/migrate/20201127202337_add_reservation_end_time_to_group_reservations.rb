class AddReservationEndTimeToGroupReservations < ActiveRecord::Migration[6.0]
  def change
    add_column :group_reservations, :reservation_end_time, :time
  end
end

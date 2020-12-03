class AddHostToGroupReservations < ActiveRecord::Migration[6.0]
  def change
    add_column :group_reservations, :host, :integer
  end
end

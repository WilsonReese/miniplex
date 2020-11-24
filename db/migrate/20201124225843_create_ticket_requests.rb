class CreateTicketRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :ticket_requests do |t|
      t.integer :user_id
      t.integer :group_id
      t.string :ticket_status
      t.string :ticket

      t.timestamps
    end
  end
end

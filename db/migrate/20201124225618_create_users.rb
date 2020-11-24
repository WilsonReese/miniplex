class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :phone_number
      t.string :street_address
      t.string :city
      t.string :zip_code
      t.boolean :admin

      t.timestamps
    end
  end
end

class CreateMovies < ActiveRecord::Migration[6.0]
  def change
    create_table :movies do |t|
      t.string :title
      t.float :duration
      t.text :description
      t.boolean :currently_showing

      t.timestamps
    end
  end
end

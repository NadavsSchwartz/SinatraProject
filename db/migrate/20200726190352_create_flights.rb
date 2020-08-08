class CreateFlights < ActiveRecord::Migration
  def change
    create_table :flights do |t|
      t.string :cost
      t.text :origin_date
      t.text :depart_time
      t.text :arrival_time
      t.string :origin
      t.string :destination

      t.timestamps null: false
    end
  end
end

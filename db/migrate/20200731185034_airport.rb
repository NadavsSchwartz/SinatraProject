class Airport < ActiveRecord::Migration
  def change
    create_table :airports do |t|
      t.string :state
      t.string :iata_code
      t.string :iso_code
      t.string :name
    end
  end
end
# 

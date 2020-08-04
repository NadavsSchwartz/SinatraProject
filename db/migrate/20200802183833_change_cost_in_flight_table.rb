class ChangeCostInFlightTable < ActiveRecord::Migration
  def change
    change_column :flights, :cost, :string
  end
end

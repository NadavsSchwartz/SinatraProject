class AddIataCodeToOriginAndDestinationInFlights < ActiveRecord::Migration
  def change
    add_column :flights, :origin_iata_code, :string
    add_column :flights, :return_iata_code, :string
  end
end

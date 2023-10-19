class AddUniqueIndexToAirportsIata < ActiveRecord::Migration[7.1]
  def change
    add_index :airports, :iata, unique: true
  end
end

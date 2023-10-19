class CreateAirports < ActiveRecord::Migration[7.1]
  def change
    create_table :airports do |t|
      t.string :iata
      t.string :city
      t.string :country
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end

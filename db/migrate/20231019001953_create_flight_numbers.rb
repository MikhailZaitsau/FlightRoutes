# frozen_string_literal: true

class CreateFlightNumbers < ActiveRecord::Migration[7.1]
  def change
    create_table :flight_numbers do |t|
      t.string :flight_number

      t.timestamps
    end
  end
end

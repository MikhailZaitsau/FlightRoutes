# frozen_string_literal: true

class CreateLegs < ActiveRecord::Migration[7.1]
  def change
    create_table :legs do |t|
      t.string :departure
      t.string :arrival
      t.integer :distance
      t.references :flight_number, null: false, foreign_key: true

      t.timestamps
    end
  end
end

# frozen_string_literal: true

class AddUniqueIndexToAlightNumbersFlightNumber < ActiveRecord::Migration[7.1]
  def change
    add_index :flight_numbers, :flight_number, unique: true
  end
end

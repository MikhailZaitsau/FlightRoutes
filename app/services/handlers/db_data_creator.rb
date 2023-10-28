# frozen_string_literal: true

module Handlers
  class DbDataCreator
    def call(route, distance, flight_number)
      create_flightnumber(flight_number)
      create_leg(route, distance)
      nil
    end

    private

    def create_flightnumber(flight_number)
      FlightNumber.create(flight_number:)
    end

    def create_leg(route, distance)
      departure = route[:departure][:iata]
      arrival = route[:arrival][:iata]
      flight_number_id = FlightNumber.last.id
      Leg.create(departure:, arrival:, distance:, flight_number_id:)
    end
  end
end

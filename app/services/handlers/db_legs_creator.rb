# frozen_string_literal: true

module Handlers
  class DbLegsCreator
    def call(route, distance)
      create_leg(route, distance)
      nil
    end

    private

    def create_leg(route, distance)
      departure = route[:departure][:iata]
      arrival = route[:arrival][:iata]
      flight_number_id = FlightNumber.last.id
      Leg.create(departure:, arrival:, distance:, flight_number_id:)
    end
  end
end

module Handlers
  class LegsCreator
    def call(route)
      @route = route
      nil
    end

    private

    def create_leg
      departure = route[:departure][:iata]
      arrival = route[:arrival][:iata]
      distance = distance_fetcher[:route][:distance]
      flight_number_id = FlightNumber.last.id
      Leg.create(departure:, arrival:, distance:, flight_number_id:)
    end

    def distance_fetcher
      Handlers::HashGenerator.new.call(@route)
    end
  end
end

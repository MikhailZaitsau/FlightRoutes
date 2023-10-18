# frozen_string_literal: true

module Handlers
  class ResponseHandler < Core::Service
    def call(route_response)
      @parsed_response = JSON.parse(route_response)
      return Failure(Handlers::ErrorMessageHandler.new.call('Flight route not found')) if @parsed_response['meta']['count'] < 1

      legs_counter
    end

    private

    def legs_counter
      if @parsed_response['data'][0]['legs'].count == 1
        one_leg(leg: @parsed_response['data'][0]['legs'][0])
      else
        few_legs(flight_data: @parsed_response['data'])
      end
    end

    def one_leg(leg:)
      @leg = leg
      departure = fetch_airports_data(@leg['boardPointIataCode'])
      arrival = fetch_airports_data(@leg['offPointIataCode'])
      route = { departure:, arrival: }
      generate_hash(route:)
    end

    def few_legs(flight_data:)
      @flight_data = flight_data
      route = []
      @flight_data[0]['legs'].each { route << one_leg(leg:).expect(:status, :error_message) }
      generate_hash(route:)
    end

    def generate_hash(route:)
      @route = route
      @airports_coordinates = if @route.is_a?(Hash)
                                [@route[:departure][:latitude], @route[:departure][:longitude],
                                @route[:arrival][:latitude], @route[:arrival][:longitude]]
                              else
                                [@route[0][:departure][:latitude], @route[0][:departure][:longitude],
                                @route[-1][:arrival][:latitude], @route[-1][:arrival][:longitude]]
                              end
      { route: @route, status: 'OK', distance: calculate_distance(@airports_coordinates), error_message: nil }
    end

    def fetch_airports_data(airport_iata_code)
      Handlers::AirportDataFetcher.new.call(airport_iata_code)
    end

    def calculate_distance(airports_coordinates)
      Handlers::DistanceCalculator.new.call(airports_coordinates)
    end
  end
end

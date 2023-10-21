# frozen_string_literal: true

module Handlers
  class ResponseHandler < Core::Service
    def call(route_response)
      @parsed_response = JSON.parse(route_response)
      if @parsed_response['meta']['count'] < 1
        return Failure(Handlers::ErrorMessageHandler.new.call('Flight route not found'))
      end

      legs_counter
    end

    private

    def legs_counter
      if @parsed_response['data'][0]['legs'].count == 1
        generate_hash_for_each_leg(@parsed_response['data'][0]['legs'][0])
      else
        generate_hash_for_multi_leg_rote(@parsed_response['data'])
      end
    end

    def generate_hash_for_each_leg(leg)
      departure = fetch_airports_data(leg['boardPointIataCode'])
      arrival = fetch_airports_data(leg['offPointIataCode'])
      route = { departure:, arrival: }
      create_leg_in_db(route)
      generate_hash(route)
    end

    def generate_hash_for_multi_leg_rote(flight_data)
      @flight_data = flight_data
      route = []
      @flight_data[0]['legs'].each { |leg| route << generate_hash_for_each_leg(leg).except(:status, :error_message) }
      generate_hash(route)
    end

    def create_leg_in_db(route)
      Handlers::DbLegsCreator.new.call(route)
    end

    def generate_hash(route_from_api)
      Handlers::HashGenerator.new.call(route_from_api:)
    end

    def fetch_airports_data(airport_iata_code)
      Handlers::AirportDataFetcher.new.call(airport_iata_code)
    end
  end
end

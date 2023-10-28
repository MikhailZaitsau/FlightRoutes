# frozen_string_literal: true

module Handlers
  class FlightNumberHandler < Core::Service
    def call(flight_number)
      @normalized_flight_number = yield check_and_normalize_flight_number(flight_number)
      if check_if_data_in_db(@normalized_flight_number)
        handle_route_from_database(check_if_data_in_db(@normalized_flight_number))
      else
        fetch_and_handle_route_from_api
      end
    end

    private

    def handle_route_from_database(route_from_db)
      @need_create_leg_in_db = false
      if route_from_db.is_a?(Hash)
        generate_single_leg_route_hash(route_from_db)
      else
        generate_multi_leg_route_hash(route_from_db)
      end
    end

    def fetch_and_handle_route_from_api
      route = yield fetch_route_from_api
      @need_create_leg_in_db = true
      if route.count == 1
        generate_single_leg_route_hash(route[0])
      else
        generate_multi_leg_route_hash(route)
      end
    end

    def generate_single_leg_route_hash(route_data)
      departure = fetch_airports_data(route_data[:departure] || route_data['boardPointIataCode'])
      arrival = fetch_airports_data(route_data[:arrival] || route_data['offPointIataCode'])
      return departure unless departure.is_a?(Hash)
      return arrival unless arrival.is_a?(Hash)

      route = { departure:, arrival: }
      distance = route_data[:distance] || calculate_distance(route)
      Handlers::DbDataCreator.new.call(route, distance, @normalized_flight_number) if @need_create_leg_in_db
      Success(generate_hash({ route:, distance: }))
    end

    def generate_multi_leg_route_hash(route_data)
      route = []
      route_data.each { |leg| route << generate_single_leg_route_hash(leg).success[:route].except(:status, :error_message) }
      distance = calculate_distance(route)
      Success(generate_hash({ route:, distance: }))
    end

    def check_and_normalize_flight_number(flight_number)
      Handlers::NumberNormalizer.new.call(flight_number)
    end

    def check_if_data_in_db(flight_number_or_iata_code)
      Handlers::DatabaseCheker.new.call(flight_number_or_iata_code)
    end

    def fetch_header_token
      @fetch_header_token ||= yield Authorization::HeaderToken.new.call
    end

    def fetch_route_from_api
      Handlers::RoutesFetcher.new.call(@normalized_flight_number, fetch_header_token)
    end

    def generate_hash(route_data)
      yield Handlers::HashGenerator.new.call(route_data:)
    end

    def fetch_airports_data(airport_iata_code)
      return check_if_data_in_db(airport_iata_code) if check_if_data_in_db(airport_iata_code)

      yield Handlers::AirportDataFetcher.new.call(airport_iata_code, fetch_header_token)
    end

    def calculate_distance(route)
      yield Handlers::DistanceCalculator.new.call(route)
    end
  end
end

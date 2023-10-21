# frozen_string_literal: true

module Handlers
  class HashGenerator < Core::Service
    def call(route_or_airport_data)
      if route_or_airport_data[:route_from_db]
        generate_hash_for_db_data(route_or_airport_data[:route_from_db])
      elsif route_or_airport_data[:airport_data]
        generate_airport_hash(route_or_airport_data[:airport_data])
      else
        generate_hash_for_api_data(route_or_airport_data[:route_from_api])
      end
    end

    private

    def generate_hash_for_db_data(route_from_db)
      if route_from_db.is_a?(Hash)
        generate_route_hash(route_from_db, route_from_db[:distance])
      else
        generate_hash_for_multileg_route_form_db(route_from_db)
      end
    end

    def generate_hash_for_multileg_route_form_db(route_from_db)
      departure = fetch_airports_data(route_from_db[0][:departure])
      arrival = fetch_airports_data(route_from_db[-1][:arrival])
      distance = calculate_distance(single_leg_coordinates(departure:, arrival:))
      generate_route_hash(route_from_db, distance)
    end

    def generate_airport_hash(airport_data)
      {
        iata: airport_data['iataCode'],
        city: airport_data.dig('address', 'cityName'),
        country: airport_data.dig('address', 'countryName'),
        latitude: airport_data.dig('geoCode', 'latitude'),
        longitude: airport_data.dig('geoCode', 'longitude')
      }
    end

    def generate_hash_for_api_data(route_from_api)
      distance = if route_from_api.is_a?(Hash)
                   calculate_distance(single_leg_coordinates(route_from_api))
                 else
                   calculate_distance(multi_legs_coordinates(route_from_api))
                 end
      generate_route_hash(route_from_api, distance)
    end

    def generate_route_hash(route, distance)
      { route:, status: 'OK', distance:, error_message: nil }
    end

    def single_leg_coordinates(route)
      [route.dig(:departure, :latitude),
       route.dig(:departure, :longitude),
       route.dig(:arrival, :latitude),
       route.dig(:arrival, :longitude)]
    end

    def multi_legs_coordinates(route)
      [route.dig(0, :route, :departure, :latitude),
       route.dig(0, :route, :departure, :longitude),
       route.dig(-1, :route, :arrival, :latitude),
       route.dig(-1, :route, :arrival, :longitude)]
    end

    def fetch_airports_data(airport_iata_code)
      Handlers::AirportDataFetcher.new.call(airport_iata_code)
    end

    def calculate_distance(airports_coordinates)
      Handlers::DistanceCalculator.new.call(airports_coordinates)
    end
  end
end

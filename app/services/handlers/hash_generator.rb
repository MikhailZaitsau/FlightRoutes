# frozen_string_literal: true

module Handlers
  class HashGenerator < Core::Service
    def call(route_or_airport_data)
      if route_or_airport_data.is_a?(Hash) && route_or_airport_data['type'] == 'location'
        generate_airport_hash(route_or_airport_data)
      else
        generate_route_hash(route_or_airport_data)
      end
    end

    private

    def generate_route_hash(route)
      @airports_coordinates = if route.is_a?(Hash)
                                single_leg_coordinates(route)
                              else
                                multi_legs_coordinates(route)
                              end
      { route:, status: 'OK', distance: calculate_distance(@airports_coordinates), error_message: nil }
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

    def calculate_distance(airports_coordinates)
      Handlers::DistanceCalculator.new.call(airports_coordinates)
    end
  end
end

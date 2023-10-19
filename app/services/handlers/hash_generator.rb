# frozen_string_literal: true

module Handlers
  class HashGenerator < Core::Service
    def call(route_or_airport_data)
      @hash_data = route_or_airport_data
      if @hash_data.is_a?(Array) && @hash_data[0][:distance]
        find_multileg_form_db_distance 
      elsif @hash_data.is_a?(Hash) && @hash_data['type'] == 'location'
        generate_airport_hash(@hash_data)
      else
        distance = find_distance
        generate_route_hash(@hash_data, distance)
      end
    end

    private

    def find_multileg_form_db_distance
      departure = fetch_airports_data(@hash_data[0][:departure])
      arrival = fetch_airports_data(@hash_data[-1][:arrival])
      distance = calculate_distance(single_leg_coordinates(departure:, arrival:))
      generate_route_hash(@hash_data, distance)
    end

    def find_airport_coordinates
      if @hash_data.is_a?(Hash)
        single_leg_coordinates(@hash_data)
      else
        multi_legs_coordinates(@hash_data)
      end
    end

    def find_distance
      if @hash_data.include?(:distance)
        @hash_data[:distance]
      else
        calculate_distance(find_airport_coordinates)
      end
    end

    def generate_route_hash(route, distance)
      { route:, status: 'OK', distance:, error_message: nil }
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

    def fetch_airports_data(airport_iata_code)
      Handlers::AirportDataFetcher.new.call(airport_iata_code)
    end

    def calculate_distance(airports_coordinates)
      Handlers::DistanceCalculator.new.call(airports_coordinates)
    end
  end
end

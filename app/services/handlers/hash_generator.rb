# frozen_string_literal: true

module Handlers
  class HashGenerator < Core::Service
    def call(route_or_airport_data)
      if route_or_airport_data[:airport_data]
        Success(generate_airport_hash(route_or_airport_data[:airport_data]))
      elsif route_or_airport_data[:route_data]
        Success(generate_route_hash(route_or_airport_data[:route_data]))
      else
        Failure(Handlers::ErrorMessageHandler.new.call('Wrong data for hash generate'))
      end
    end

    private

    def generate_airport_hash(airport_data)
      {
        iata: airport_data['iataCode'],
        city: airport_data.dig('address', 'cityName'),
        country: airport_data.dig('address', 'countryName'),
        latitude: airport_data.dig('geoCode', 'latitude'),
        longitude: airport_data.dig('geoCode', 'longitude')
      }
    end

    def generate_route_hash(route_data)
      { route: route_data[:route], status: 'OK', distance: route_data[:distance], error_message: nil }
    end
  end
end

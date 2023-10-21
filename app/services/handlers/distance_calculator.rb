# frozen_string_literal: true

module Handlers
  class DistanceCalculator < Core::Service
    # A service that calculates the distance between two airports based on their coordinates using the haversine formula
    def call(airports_coordinates)
      airports_coordinates_in_radians = to_radians(airports_coordinates)
      haversine_distance(*airports_coordinates_in_radians)
    end

    private

    EARTH_RADIUS = 6371

    def hav(angle)
      Math.sin(angle / 2)**2
    end

    def arc_hav(data)
      2 * Math.asin(Math.sqrt(data))
    end

    def to_radians(degrees)
      degrees.map { |coordinates| coordinates * Math::PI / 180 }
    end

    def haversine_distance(departure_latitude, departure_longitude, arrival_latitude, arrival_longitude)
      haversine = arc_hav(hav(arrival_latitude - departure_latitude) + (
        Math.cos(departure_latitude) * Math.cos(arrival_latitude) * hav(
          arrival_longitude - departure_longitude
        )))

      (haversine * EARTH_RADIUS).round
    end
  end
end

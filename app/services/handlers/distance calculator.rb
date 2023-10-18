# frozen_string_literal: true

module Handlers
  class DistanceCalculator < Core::Service
    def call(airports_coordinates:)
      @airports_coordinates = airports_coordinates
      haversine_distance(*@airports_coordinates)
    end
  end
end

private

EARTH_RADIUS = 6371

def hav(angle)
  Math.sin(angle / 2)**2
end

def arc_hav(x)
  2 * Math.asin(Math.sqrt(x))
end

def to_radians(degrees)
  degrees * Math::PI / 180
end

def haversine_distance(departure_latitude, departure_longitude, arrival_latitude, arrival_longitude)
  departure_latitude_in_radians = to_radians(departure_latitude)
  departure_longitude_in_radians = to_radians(departure_longitude)
  arrival_latitude_in_radians = to_radians(arrival_latitude)
  arrival_longitude_in_radians = to_radians(arrival_longitude)

  d = arc_hav(hav(arrival_latitude_in_radians - departure_latitude_in_radians) + (Math.cos(departure_latitude_in_radians) * Math.cos(arrival_latitude_in_radians) * hav(arrival_longitude_in_radians - departure_longitude_in_radians)))

  d * EARTH_RADIUS
end

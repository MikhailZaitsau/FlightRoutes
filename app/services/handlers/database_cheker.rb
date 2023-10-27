# frozen_string_literal: true

module Handlers
  class DatabaseCheker < Core::Service
    def call(flight_number_or_iata_code)
      @query_data = flight_number_or_iata_code
      if @query_data =~ /\A([A-Z0-9]{2}|[A-Z0-9]{3})(\d{1,4})\z/
        fetch_flight_number_from_db
      elsif @query_data =~ /^[A-Z]{3}$/
        fetch_airport_from_db
      else
        false
      end
    end

    private

    def fetch_flight_number_from_db
      @flight_number = FlightNumber.includes(:legs).find_by(flight_number: @query_data)
      if !@flight_number
        false
      elsif @flight_number.updated_at < 24.hours.ago
        flight_number.destroy
        false
      else
        parse_legs(@flight_number)
      end
    end

    def parse_legs(flight_number)
      legs = flight_number.legs.map(&:attributes).map(&:symbolize_keys)
                          .map { |leg| leg.except(:id, :flight_number_id, :created_at, :updated_at) }
      legs.count == 1 ? legs[0] : legs
    end

    def fetch_airport_from_db
      airport = Airport.find_by(iata: @query_data)
      airport ? airport.attributes.symbolize_keys.except(:id, :created_at, :updated_at) : false
    end
  end
end

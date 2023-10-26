# frozen_string_literal: true

module Handlers
  class RoutesFetcher < Core::Service
    def call(normalized_flight_number)
      @normalized_flight_number = normalized_flight_number
      return flight_route_from_db if flight_route_from_db

      @token_header = Authorization::HeaderToken.new.call
      return @token_header unless @token_header.is_a?(String)


      route_response = fetch_response
      if route_response.is_a?(HTTParty::Response)
        FlightNumber.create(flight_number: @normalized_flight_number)
        handle_response(route_response)
      else
        route_response
      end
    end

    private

    def iata_format
      @carrier_code = @normalized_flight_number[0, 2]
      @flight_number = @normalized_flight_number[2, 4]
    end

    def icao_format
      @carrier_code = @normalized_flight_number[0, 3]
      @flight_number = @normalized_flight_number[3, 4]
    end

    def fetch_response
      @normalized_flight_number[0, 3] =~ /\d/ ? iata_format : icao_format
      fetched_response = route_query
      if Handlers::ResponseChecker.new.call(fetched_response)
        fetched_response
      else
        Handlers::ErrorMessageHandler.new.call('Flight route not found')
      end
    end

    def route_query
      HTTParty.get(
        'https://test.api.amadeus.com/v2/schedule/flights',
        headers: { 'Authorization' => @token_header },
        query: {
          carrierCode: @carrier_code,
          flightNumber: @flight_number,
          scheduledDepartureDate: Time.zone.today.strftime('%Y-%m-%d')
        }
      )
    end

    def flight_route_from_db
      Handlers::DatabaseCheker.new.call(@normalized_flight_number)
    end

    def handle_response(route_response)
      Handlers::ResponseHandler.new.call(route_response)
    end
  end
end

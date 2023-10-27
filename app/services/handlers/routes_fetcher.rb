# frozen_string_literal: true

module Handlers
  class RoutesFetcher < Core::Service
    def call(normalized_flight_number, token)
      @normalized_flight_number = normalized_flight_number
      @token_header = token
      route_response = fetch_response
      if route_response.is_a?(HTTParty::Response)
        Success(JSON.parse(route_response)['data'][0]['legs'])
      else
        Failure(route_response)
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

    def handle_response(route_response)
      Handlers::ResponseHandler.new.call(route_response)
    end
  end
end

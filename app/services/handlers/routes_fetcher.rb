# frozen_string_literal: true

module Handlers
  class RoutesFetcher < Core::Service
    def call(normalized_flight_number)
      @normalized_flight_number = normalized_flight_number.join
      @token_header = Authorization::HeaderToken.new.call
      return Failure(@token_header) unless @token_header.is_a?(String)

      @route_response = fetch_response
      # if @route_response.is_a?(HTTParty::Response)
        Handlers::ResponseHandler.new.call(@route_response)
      # else
        # @route_response
      # end
    end

    private

    attr_reader :carrier_code, :flight_number

    def iata
      @carrier_code = @normalized_flight_number[0, 2]
      @flight_number = @normalized_flight_number[2, 4]
    end

    def icao
      @carrier_code = @normalized_flight_number[0, 3]
      @flight_number = @normalized_flight_number[3, 4]
    end

    def fetch_response
      @normalized_flight_number[0, 3] =~ /\d/ ? iata : icao
      # if route_query.code == 200 && route_query.parsed_response.length.positive?
        route_query
      # else
      #   Handlers::ErrorMessageHandler.new.call('Flight number not found')
      # end
    end

    def route_query
      File.read("amarespond.txt")
      # HTTParty.get(
      #   'https://test.api.amadeus.com/v2/schedule/flights',
      #   headers: { 'Authorization' => @token_header },
      #   query: {
      #     carrierCode: @carrier_code,
      #     flightNumber: @flight_number,
      #     scheduledDepartureDate: Time.zone.today.strftime('%Y-%m-%d')
      #   }
      # )
    end
  end
end
# frozen_string_literal: true

module Handlers
  class AirportDataFetcher < Core::Service
    def call(airport_iata_code, token)
      @airport_iata_code = airport_iata_code
      @token_header = token

      fetch_airport_from_api
    end

    private

    def fetch_airport_from_api
      @airport_response = fetch_response
      if @airport_response.is_a?(HTTParty::Response)
        airport = yield generate_hash
        Airport.create(airport)
        Success(airport)
      else
        Failure(@airport_response)
      end
    end

    def fetch_response
      fetched_response = airport_query
      if Handlers::ResponseChecker.new.call(fetched_response)
        fetched_response
      else
        Handlers::ErrorMessageHandler.new.call('Airport not found')
      end
    end

    def airport_query
      Http::AmadeusRequest.new.call(
        method: 'GET',
        url: '/v1/reference-data/locations',
        headers: { 'Authorization' => @token_header },
        query: {
          subType: 'AIRPORT', keyword: @airport_iata_code
        }
      )
    end

    def airport_data
      @airport_data ||= JSON.parse(@airport_response)['data'][0]
    end

    def generate_hash
      Handlers::HashGenerator.new.call(airport_data:)
    end
  end
end

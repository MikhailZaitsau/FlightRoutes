# frozen_string_literal: true

module Handlers
  class AirportDataFetcher < Core::Service
    def call(airport_iata_code)
      @airport_iata_code = airport_iata_code
      return airport_from_db if airport_from_db

      @token_header = Authorization::HeaderToken.new.call
      return @token_header unless @token_header.is_a?(String)

      fetch_airport_from_api
    end

    private

    def fetch_airport_from_api
      @airport_response = fetch_response
      if @airport_response.is_a?(HTTParty::Response)
        airport = generate_hash
        Airport.create(airport)
        airport
      else
        @airport_response
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
      HTTParty.get(
        'https://test.api.amadeus.com/v1/reference-data/locations',
        headers: { 'Authorization' => @token_header },
        query: {
          subType: 'AIRPORT', keyword: @airport_iata_code
        }
      )
    end

    def airport_data
      JSON.parse(@airport_response)['data'][0]
    end

    def airport_from_db
      Handlers::DatabaseCheker.new.call(@airport_iata_code)
    end

    def generate_hash
      Handlers::HashGenerator.new.call(airport_data:)
    end
  end
end

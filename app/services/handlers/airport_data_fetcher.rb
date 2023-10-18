# frozen_string_literal: true

module Handlers
  class AirportDataFetcher < Core::Service
    def call(airport_iata_code:)
      @airport_iata_code = airport_iata_code
      @token_header = Tokens::HeaderToken.new.call
      return Failure(@token_header) unless @token_header.is_a?(String)

      @airport_response = yield fetch_response
      if @airport_response.is_a?(HTTParty::Response)
        generate_hash
      else
        @airport_response
      end
    end
  end
end

private

def fetch_response
  if airport_query.code == 200 && airport_query.parsed_response.length.positive?
    airport_query
  else
    Handlers::ErrorMessageHandler.new.call('Airport not found', :not_found)
  end
end

def airport_query
  HTTParty.get(
    'https://test.api.amadeus.com/v1/reference-data/locations',
    headers: { 'Authorization' => token_header },
    query: {
      subType: 'AIRPORT', keyword: @airport_iata_code
    }
  )
end

def airport_data
  @airport_data ||= JSON.parse(@airport_response)['data'][0]
end

def generate_hash
  {
    iata: airport_data['iataCode'],
    city: airport_data.dig('address', 'cityName'),
    country: airport_data.dig('address', 'countryName'),
    latitude: airport_data.dig('geoCode', 'latitude'),
    longitude: airport_data.dig('geoCode', 'longitude')
  }
end

# frozen_string_literal: true

module Tokens
  class HeaderToken < Core::Service
    include 'httparty'
    def call
      result = yield token
      result.is_a?(String) ? "Bearer #{result}" : result
    end

    private

    client_id = ENV.fetch('AMADEUS_CLIENT_ID', nil)
    client_secret = ENV.fetch('AMADEUS_CLIENT_SECRET', nil)

    @auth_header = "Basic #{Base64.strict_encode64("#{client_id}:#{client_secret}")}"

    def token
      return @access_token if @access_token && !needs_refresh?

      update_access_token
      @access_token
    end

    def needs_refresh?
      @access_token.nil? || (Time.current + 10) > @expires_at
    end

    def update_access_token
      response = fetch_access_token
      store_access_token(response.result)
    end

    def fetch_access_token
      if auth_request.code == 200 && auth_request.parsed_response.length.positive?
        auth_request
      else
        { route: nil, status: 'FAIL', distance: 0, error_message: 'Authorization error' }
      end
    end

    def auth_request
      HTTParty.post(
        'https://test.api.amadeus.com/v1/security/oauth2/token',
        headers: { 'Authorization' => @auth_header },
        body: { 'grant_type' => 'client_credentials' }
      )
    end

    def store_access_token(data)
      @access_token = data['access_token']
      @expires_at = Time.current + data['expires_in']
    end
  end
end

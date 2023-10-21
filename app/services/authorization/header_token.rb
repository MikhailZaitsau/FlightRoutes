# frozen_string_literal: true

require 'httparty'
module Authorization
  class HeaderToken < Core::Service
    def call
      encripted_header
      result = token

      result.is_a?(String) ? "Bearer #{result}" : result
    end

    private

    def encripted_header
      client_id = ENV.fetch('AMADEUS_CLIENT_ID', nil)
      client_secret = ENV.fetch('AMADEUS_CLIENT_SECRET', nil)
      @auth_header = "Basic #{Base64.strict_encode64("#{client_id}:#{client_secret}")}"
    end

    def token
      @access_token = AuthToken.last
      return @access_token if @access_token && !needs_refresh?

      update_access_token
      @access_token
    end

    def needs_refresh?
      @access_token.nil? || (Time.current + 10) > @access_token.expires_at
    end

    def update_access_token
      @access_token&.destroy
      response = fetch_access_token
      store_access_token(response)
    end

    def fetch_access_token
      if auth_request.code == 200 && auth_request.parsed_response.length.positive?
        auth_request
      else
        Handlers::ErrorMessageHandler.new.call('Authorization error')
      end
    end

    def auth_request
      HTTParty.post(
        'https://test.api.amadeus.com/v1/security/oauth2/token',
        headers: { 'Authorization' => @auth_header },
        body: { 'grant_type' => 'client_credentials' }
      )
    end

    def store_access_token(response)
      @access_token = response['access_token']
      expires_at = Time.current + response['expires_in']
      AuthToken.create(token: @access_token, expires_at:)
    end
  end
end

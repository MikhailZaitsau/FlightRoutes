# frozen_string_literal: true

require 'httparty'
module Authorization
  class HeaderToken < Core::Service
    def call
      encripted_header
      Success(token) || Failure(@error)
    end

    private

    def encripted_header
      client_id = ENV.fetch('AMADEUS_CLIENT_ID', nil)
      client_secret = ENV.fetch('AMADEUS_CLIENT_SECRET', nil)
      @auth_header = "Basic #{Base64.strict_encode64("#{client_id}:#{client_secret}")}"
    end

    def token
      return @access_token if @access_token

      update_access_token
      @access_token
    end

    def update_access_token
      response = fetch_access_token
      if response['access_token']
        store_access_token(response)
      else
        @error = response
      end
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
      Rails.cache.fetch('header token', expires_in: response['expires_in'] - 10) do
        @access_token = response['access_token']
      end
    end
  end
end

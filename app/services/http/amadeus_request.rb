# frozen_string_literal: true

module Http
  class AmadeusRequest < Core::Service
    include HTTParty
    base_uri ENV.fetch('AMADEUS_TEST') == 'true' ? 'https://test.api.amadeus.com' : 'https://api.amadeus.com'
    def call(params)
      @request_url = params[:url]
      @request_body = params[:body]
      @request_method = params[:method]
      @request_headers = params[:headers]
      @request_query = params[:query]
      request
    end

    private

    def request
      case @request_method
      when 'GET'
        self.class.get(@request_url, headers: @request_headers, query: @request_query)
      when 'POST'
        self.class.post(@request_url, headers: @request_headers, body: @request_body)
      else
        Handlers::ErrorMessageHandler.new.call('Unsupported request method')
      end
    end
  end
end

# frozen_string_literal: true

module Handlers
  class NumberNormalizer < Core::Service
    def call(flight_number:)
      @flight_number = flight_number.uppercase

      if @flight_number =~ /\A([A-Z0-9]{2}|[A-Z0-9]{3})(\d{1,4})\z/
        Success("#{::Regexp.last_match(1)}#{::Regexp.last_match(2).rjust(4, '0')}")
      else
        Failure({ route: nil, status: 'FAIL', distance: 0, error_message: 'Invalid flight number format' })
      end
    end
  end
end

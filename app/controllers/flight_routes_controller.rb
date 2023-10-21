# frozen_string_literal: true

class FlightRoutesController < ApplicationController
  include Dry::Monads::Result::Mixin

  def index
    @input_data = params[:flight_number]
    if @input_data.present? && @input_data.is_a?(String)
      render json: fetch_flight_route_by_flight_number
    else
      Handlers::ErrorMessageHandler.new.call('Flight number not received')
    end
  end

  private

  def fetch_flight_route_by_flight_number
    case check_and_normalize_flight_number
    in Success(normalized_flight_number)
      fetch_route_from_api_or_db(normalized_flight_number)
    in Failure(error)
      error
    end
  end

  def check_and_normalize_flight_number
    Handlers::NumberNormalizer.new.call(@input_data)
  end

  def fetch_route_from_api_or_db(normalized_flight_number)
    Handlers::RoutesFetcher.new.call(normalized_flight_number)
  end
end

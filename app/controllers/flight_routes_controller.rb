# frozen_string_literal: true

class FlightRoutesController < ApplicationController
  include Dry::Monads::Result::Mixin

  def index
    @flight_number = params[:flight_number]

    if @flight_number.present?
      render json: fetch_flight_route_by_flight_number
    else
      Handlers::ErrorMessageHandler.new.call('Flight number not received')
    end
  end

  private

  attr_reader :normalized_flight_number

  def fetch_flight_route_by_flight_number
    case check_and_normalize_flight_number
    in Success(*normalized_flight_number)
      fetch_route_from_api_or_db(normalized_flight_number)
    in Failure(error)
      render json: error
    end
  end

  def check_and_normalize_flight_number
    Handlers::NumberNormalizer.new.call(@flight_number)
  end

  def fetch_route_from_api_or_db(normalized_flight_number)
    Handlers::RoutesFetcher.new.call(normalized_flight_number)
  end
end

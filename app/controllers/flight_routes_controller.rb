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
    case handle_flight_number
    in Success(flight_route)
      flight_route
    in Failure(error)
      error
    end
  end

  def handle_flight_number
    Handlers::FlightNumberHandler.new.call(@input_data)
  end
end

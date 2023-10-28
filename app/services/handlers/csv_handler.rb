# frozen_string_literal: true

module Handlers
  class CsvHandler
    include Dry::Monads::Result::Mixin
    def call(file)
      @file = file
      create_output_csv_file_with_headers
    end

    private

    def create_output_csv_file_with_headers
      @rows = [['Example flight number',
                'Flight number used for lookup',
                'Lookup status', 'Number of legs',
                'First leg departure airport IATA',
                'Last leg arrival airport IATA',
                'Ditance in kilometers']]
      fill_output_file
    end

    def fill_output_file
      CSV.open('output.csv', 'w+', headers: true) do |csv|
        ready_array_for_add_to_output_file
        @rows.each { |row| csv << row }
      end
    end

    def ready_array_for_add_to_output_file
      CSV.foreach(@file, headers: true) do |row|
        @flight_number = row[0]
        ready_data_for_output_file
        row_array = [@flight_number, @flight_number_used_for_lookup, check_lookup_status,
                     @number_of_legs, fetch_first_leg_departure_airport_iata,
                     fetch_last_leg_arrival_airport_iata, fetch_distance_in_kilometers]
        @rows << row_array
      end
    end

    def ready_data_for_output_file
      @flight_number_used_for_lookup = check_and_normalize_flight_number
      case fetch_route_from_api_or_db
      in Success(route)
        @lookup_result = route
      in Failure(error)
        @lookup_result = error
      in nil
        @lookup_result = nil
      end
      @number_of_legs = check_number_of_legs
    end

    def check_and_normalize_flight_number
      case Handlers::NumberNormalizer.new.call(@flight_number)
      in Success(number)
        number
      in Failure(message)
        return nil
      end
    end

    def fetch_route_from_api_or_db
      Handlers::FlightNumberHandler.new.call(@flight_number) if @flight_number_used_for_lookup
    end

    def check_lookup_status
      @lookup_result.is_a?(Hash) && @lookup_result[:route] ? 'OK' : 'FAIL'
    end

    def check_number_of_legs
      if @lookup_result.is_a?(Hash) && @lookup_result[:route].is_a?(Array)
        @lookup_result[:route].count
      elsif @lookup_result.is_a?(Hash) && @lookup_result[:route]
        1
      end
    end

    def fetch_first_leg_departure_airport_iata
      if @number_of_legs && @number_of_legs > 1
        @lookup_result[:route][0][:route][:departure][:iata]
      elsif @number_of_legs
        @lookup_result[:route][:departure][:iata]
      end
    end

    def fetch_last_leg_arrival_airport_iata
      if @number_of_legs && @number_of_legs > 1
        @lookup_result[:route][-1][:route][:arrival][:iata]
      elsif @number_of_legs
        @lookup_result[:route][:arrival][:iata]
      end
    end

    def fetch_distance_in_kilometers
      @lookup_result.is_a?(Hash) ? @lookup_result[:distance] : nil
    end
  end
end

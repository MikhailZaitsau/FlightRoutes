# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'FlightRoutesController' do
  describe 'GET /index' do
    let(:flightnumber) { '7C2252' }

    it 'return status OK' do
      get "/flight_routes?flight_number=#{flightnumber}"
      expect(response).to have_http_status(:ok)
    end

    it 'return JSON format' do
      get "/flight_routes?flight_number=#{flightnumber}"
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    context 'when route and airport in db' do
      let(:flight_number) { create(:flight_number) }
      let(:flightnumber) { flight_number.flight_number }
      let!(:airport) { create(:airport, iata: 'III') }
      let(:arrival) { airport.iata }

      before { create_list(:leg, 3, arrival:, flight_number:) }

      it 'find airport in database' do
        get "/flight_routes?flight_number=#{flightnumber}"
        expect(response.parsed_body['route'][0]['arrival']).to eq(airport.iata)
      end

      it 'distance beetwen firsta department and last arrival not nil' do
        get "/flight_routes?flight_number=#{flightnumber}"
        expect(response.parsed_body['distance']).should_not be_nil
      end
    end

    context 'when route not in db' do
      let(:flightnumber) { Faker::Base.regexify(/^[A-Z0-9]{2,3}\d{4}$/) }

      it 'return status OK' do
        get "/flight_routes?flight_number=#{flightnumber}"
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when flight number invalid or not received' do
      it 'return an error invalid number' do
        get "/flight_routes?flight_number=''"
        expect(response.parsed_body['error_message']).to eq('Invalid flight number format')
      end

      it 'return an error number not received' do
        get "/flight_routes?flight_number='0942AB'"
        expect(response.parsed_body['error_message']).to eq('Invalid flight number format')
      end
    end
  end
end

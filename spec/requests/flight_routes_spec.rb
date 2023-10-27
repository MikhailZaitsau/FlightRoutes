# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'FlightRoutesController' do
  describe 'GET /index' do
    let(:flightnumber) { 'LH2479' }

    it 'return status OK' do
      VCR.use_cassette('full_route') { get "/flight_routes?flight_number=#{flightnumber}" }
      expect(response).to have_http_status(:ok)
    end

    it 'return JSON format' do
      VCR.use_cassette('full_route') { get "/flight_routes?flight_number=#{flightnumber}" }
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it 'create flight number in database' do
      VCR.use_cassette('full_route') { get "/flight_routes?flight_number=#{flightnumber}" }
      expect(FlightNumber.last.flight_number).to eq(flightnumber)
    end

    context 'when route and airport in db' do
      let(:flight_number) { create(:flight_number) }
      let(:flightnumber) { flight_number.flight_number }
      let!(:airport) { create(:airport, iata: 'III') }
      let(:arrival) { airport.iata }

      before { create_list(:leg, 3, arrival:, flight_number:) }

      it 'find airport in database' do
        VCR.use_cassette('full_db_route') { get "/flight_routes?flight_number=#{flightnumber}" }
        expect(response.parsed_body['route'][0]['arrival']['iata']).to eq(airport.iata)
      end

      it 'distance between first department and last arrival are present' do
        VCR.use_cassette('full_db_route') { get "/flight_routes?flight_number=#{flightnumber}" }
        expect(response.parsed_body['distance']).not_to be_nil
      end

      it 'distance beetwen firsta department and last arrival not zero' do
        VCR.use_cassette('full_db_route') { get "/flight_routes?flight_number=#{flightnumber}" }
        expect(response.parsed_body['distance'].to_i).to be > 0
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

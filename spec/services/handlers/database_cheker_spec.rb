# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Handlers::DatabaseCheker do
  describe 'call' do
    let(:flight_number) { Faker::Base.regexify(/^[A-Z0-9]{2,3}\d{4}$/) }

    context 'when called with new flight number' do
      it 'returns false' do
        response = described_class.new.call(flight_number)
        expect(response).to be(false)
      end
    end

    context 'when called with flight number is already in the database' do
      before do
        create(:flight_number, flight_number:)
        create(:leg, flight_number_id: FlightNumber.last.id)
      end

      it 'returns FlightNumber from database' do
        response = described_class.new.call(flight_number)
        expect(response[:distance]).to eq(Leg.last.distance)
      end
    end

    context 'when called with flight number is already in the database but have no any leg' do
      before do
        create(:flight_number)
        create(:flight_number, flight_number:)
      end

      it 'delete FlightNumber' do
        described_class.new.call(flight_number)
        expect(FlightNumber.last.flight_number).not_to eq(flight_number)
      end

      it 'returns false' do
        response = described_class.new.call(flight_number)
        expect(response).to be(false)
      end
    end

    context 'when called with new airport iata code' do
      let(:iata) { Faker::Base.regexify(/^[A-Z]{3}$/) }

      it 'returns false' do
        response = described_class.new.call(iata:)
        expect(response).to be(false)
      end
    end

    context 'when called with airport iata code which already in the database' do
      let!(:airport) { create(:airport) }

      it 'returns FlightNumber from database' do
        expect(Airport.last.iata).to eq(airport.iata)
      end
    end
  end
end

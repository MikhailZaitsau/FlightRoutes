# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Handlers::DatabaseCheker do
  describe 'call' do
    context 'when called with new flight number' do
      let(:flightnumber) { Faker::Base.regexify(/^[A-Z0-9]{2,3}\d{4}$/) }

      it 'returns false' do
        response = described_class.new.call(flightnumber)
        expect(response).to be(false)
      end
    end

    context 'when called with flight number is already in the database' do
      let(:flight_number) { Faker::Base.regexify(/^[A-Z0-9]{2,3}\d{4}$/) }

      before { FlightNumber.create(flight_number:) }

      it 'returns FlightNumber from database' do
        expect(FlightNumber.last.flight_number).to eq(flight_number)
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

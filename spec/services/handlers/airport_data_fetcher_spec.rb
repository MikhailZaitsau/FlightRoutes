# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Handlers::AirportDataFetcher do
  describe 'call' do
    let(:airport_iata_code) { 'LHR' }
    let(:token) { Authorization::HeaderToken.new.call.success }
    let(:lhr) { { iata: 'LHR', city: 'LONDON', country: 'UNITED KINGDOM', latitude: 51.4775, longitude: -0.46138 } }

    it 'returns the requested airport data' do
      airport_data = VCR.use_cassette('ariport_lhr') { described_class.new.call(airport_iata_code, token) }
      expect(airport_data.success).to eq(lhr)
    end

    context 'when try to find non existing airport' do
      let(:airport_iata_code) { 'OOO' }
      let(:error) { { route: nil, status: 'FAIL', distance: 0, error_message: 'Airport not found' } }

      it 'returns an error' do
        airport_data = VCR.use_cassette('ariport_ooo') { described_class.new.call(airport_iata_code, token) }
        expect(airport_data.failure).to eq(error)
      end
    end
  end
end

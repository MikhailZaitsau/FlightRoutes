# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Handlers::HashGenerator do
  describe 'call' do
    context 'when call with route data' do
      let(:departure) { { city: 'MUNICH', country: 'GERMANY', iata: 'MUC', latitude: 48.35389, longitude: 11.78612 } }
      let(:arrival) do
        { city: 'LONDON', country: 'UNITED KINGDOM', iata: 'LHR', latitude: 51.4775, longitude: -0.46138 }
      end
      let(:distance) { 942 }
      let(:route) { { departure:, arrival: } }
      let(:route_data) { { route:, distance: } }

      it 'returns correct route hash' do
        result = described_class.new.call(route_data:)
        expect(result.success).to eq({ route:, status: 'OK', distance:, error_message: nil })
      end
    end

    context 'when call with airport data' do
      let(:token) { Authorization::HeaderToken.new.call.success }
      let(:airport_response) do
        VCR.use_cassette('ariport_lhr') do
          HTTParty.get(
            'https://test.api.amadeus.com/v1/reference-data/locations',
            headers: { 'Authorization' => token },
            query: {
              subType: 'AIRPORT', keyword: 'LHR'
            }
          )
        end
      end
      let(:airport_data) { JSON.parse(airport_response)['data'][0] }
      let(:expected_result) do
        { iata: 'LHR', city: 'LONDON', country: 'UNITED KINGDOM', latitude: 51.4775, longitude: -0.46138 }
      end

      it 'returns correct route hash' do
        result = described_class.new.call(airport_data:)
        expect(result.success).to eq(expected_result)
      end
    end
  end
end

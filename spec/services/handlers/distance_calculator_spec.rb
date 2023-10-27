# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Handlers::DistanceCalculator do
  describe 'call' do
    let(:departure) { { city: 'MUNICH', country: 'GERMANY', iata: 'MUC', latitude: 48.35389, longitude: 11.78612 } }
    let(:arrival) { { city: 'LONDON', country: 'UNITED KINGDOM', iata: 'LHR', latitude: 51.4775, longitude: -0.46138 } }
    let(:route) { { departure:, arrival: } }
    let(:multi_route) { [{ departure:, arrival: }, { departure:, arrival: }] }

    it 'count distance correctly for single leg route' do
      distance = described_class.new.call(route).success
      expect(distance).to eq(942)
    end

    it 'count distance correctly for multi leg route' do
      distance = described_class.new.call(multi_route).success
      expect(distance).to eq(942)
    end

    context 'when called with wrong coordinates' do
      let(:arrival) { { city: 'LONDON', country: 'UNITED KINGDOM', iata: 'LHR', latitude: nil, longitude: -0.46138 } }

      it 'returns an error' do
        distance = described_class.new.call(route).failure
        expect(distance).to eq(Handlers::ErrorMessageHandler.new.call('Wrong coordinates'))
      end
    end
  end
end

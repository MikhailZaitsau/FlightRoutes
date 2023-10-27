# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Handlers::RoutesFetcher do
  describe 'call' do
    let(:token) { Authorization::HeaderToken.new.call.success }

    context 'when the flight number is found' do
      let(:normalized_flight_number) { 'LH2479' }

      it 'returns route hash' do
        result = VCR.use_cassette('routes_fetcher') { described_class.new.call(normalized_flight_number, token) }
        expect(result.success[0]['boardPointIataCode']).to eq('LHR')
      end
    end

    context 'when the flight number is not found' do
      let(:normalized_flight_number) { 'XX7777' }

      it 'returns error' do
        result = VCR.use_cassette('not_found') { described_class.new.call(normalized_flight_number, token) }
        expect(result.failure[:error_message]).to eq('Flight route not found')
      end
    end
  end
end

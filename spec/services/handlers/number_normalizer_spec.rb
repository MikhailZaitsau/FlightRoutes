# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Handlers::NumberNormalizer do
  include Dry::Monads::Result::Mixin
  describe 'call' do
    context 'when the flight number is valid' do
      let(:flight_number) { 'AB4893' }

      it 'returns the same flight number' do
        normalized_flight_number = described_class.new.call(flight_number).success
        expect(normalized_flight_number).to eq(flight_number)
      end
    end

    context 'when flight number is invalid' do
      it 'return the valid flight number' do
        normalized_flight_number = described_class.new.call('PL11').success
        expect(normalized_flight_number).to eq('PL0011')
      end

      it 'return an error' do
        normalized_flight_number = described_class.new.call('POIDF8').failure
        expect(normalized_flight_number[:error_message]).to eq('Invalid flight number format')
      end
    end
  end
end

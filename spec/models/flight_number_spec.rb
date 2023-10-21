# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlightNumber do
  subject(:flightnumber) { described_class.create(flight_number:) }

  let(:flight_number) { 'BA2490' }

  it 'create a flight number' do
    expect(flightnumber).to be_persisted
  end
end

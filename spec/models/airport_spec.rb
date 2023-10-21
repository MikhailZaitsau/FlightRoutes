# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Airport do
  subject(:airport) { described_class.create(airport_params) }

  let(:iata) { 'LHR' }
  let(:city) { 'LONDON' }
  let(:country) { 'UNITED KINGDOM' }
  let(:latitude) { 51.47750 }
  let(:longitude) { -0.46138 }
  let(:airport_params) { { iata:, city:, country:, latitude:, longitude: } }

  it 'create an airport' do
    expect(airport).to be_persisted
  end
end

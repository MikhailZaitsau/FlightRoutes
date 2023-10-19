require 'rails_helper'

RSpec.describe Airport, type: :model do
  subject(:airport) { described_class.create(airport_params:) }

  let(:iata) { 'LHR' }
  let(:city) { 'LONDON' }
  let(:country) { 'UNITED KINGDOM' }
  let(:latitude) { 51.47750 }
  let(:longitude) { -0.46138 }
  let(:airport_params) { { iata:, city:, country:, latitude:, longitude: } }

  it 'create a flight number' do
    expect(:airport).to be_persisted
  end
end

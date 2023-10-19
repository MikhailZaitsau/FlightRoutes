require 'rails_helper'

RSpec.describe Leg do
  subject(:leg) { described_class.create(leg_params:) }

  let(:flight_number) { create(:flight_number) }
  let(:flight_number_id) { flight_number.id }
  let(:departure) { 'LHR' }
  let(:arrival) { 'LONDON' }
  let(:distance) { 'UNITED KINGDOM' }
  let(:leg_params) { { departure:, arrival:, distance:, flight_number_id: } }

  it 'create a flight number' do
    expect(:leg).to be_persisted
  end
end

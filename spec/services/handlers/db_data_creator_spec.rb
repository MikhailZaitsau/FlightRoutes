# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Handlers::DbDataCreator do
  describe 'call' do
    let(:flightnumber) { Faker::Base.regexify(/^[A-Z0-9]{2,3}\d{4}$/) }
    let(:departure) { create(:airport).attributes.symbolize_keys.except(:id, :created_at, :updated_at) }
    let(:arrival) { create(:airport).attributes.symbolize_keys.except(:id, :created_at, :updated_at) }
    let(:route) { { departure:, arrival: } }
    let(:distance) { 555 }

    it 'create flightnumber in databse' do
      described_class.new.call(route, distance, flightnumber)
      expect(FlightNumber.last.flight_number).to eq(flightnumber)
    end

    it 'create leg in databse' do
      described_class.new.call(route, distance, flightnumber)
      expect(Leg.last.flight_number_id).to eq(FlightNumber.last.id)
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Handlers::DbLegsCreator do
  describe 'call' do
    let!(:flight_number) { create(:flight_number) }
    let(:departure) { create(:airport).attributes.symbolize_keys.except(:id, :created_at, :updated_at) }
    let(:arrival) { create(:airport).attributes.symbolize_keys.except(:id, :created_at, :updated_at) }
    let(:route) { { departure:, arrival: } }
    let(:distance) { 555 }

    it 'create leg in databse' do
      described_class.new.call(route, distance)
      expect(Leg.last.flight_number_id).to eq(flight_number.id)
    end
  end
end

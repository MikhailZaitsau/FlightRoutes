# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'FlightRoutesController' do
  describe 'GET /index' do
    let(:flightnumber) { 'BA2490' }
    # let(:params) { { flightnumber: } }

    it 'return status OK' do
      get "/flight_routes?flight_number=#{flightnumber}"
      expect(response).to have_http_status(:ok)
    end

    it 'return JSON format' do
      get "/flight_routes?flight_number=#{flightnumber}"
      expect(response.content_type).to eq('application/json')
    end
  end
end

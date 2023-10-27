# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Handlers::ErrorMessageHandler do
  describe 'call' do
    let(:error_message) { 'Some error' }

    it 'returns an error with corect message' do
      error = described_class.new.call(error_message)
      expect(error[:error_message]).to eq(error_message)
    end
  end
end

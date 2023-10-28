# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Authorization::HeaderToken do
  describe 'call' do
    it 'returns a valid token' do
      token = described_class.new.call.success
      expect(token) =~ (/^Bearer\s+([^,\s]+)/)
    end

    context 'when token stored' do
      let!(:stored_token) { described_class.new.call.success }

      it 'returns a stored token' do
        received_token = described_class.new.call.success
        expect(received_token).to eq(stored_token)
      end
    end
  end
end

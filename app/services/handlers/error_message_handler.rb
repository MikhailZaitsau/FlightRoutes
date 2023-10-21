# frozen_string_literal: true

module Handlers
  class ErrorMessageHandler < Core::Service
    def call(error_message = 'nil')
      { route: nil, status: 'FAIL', distance: 0, error_message: }
    end
  end
end

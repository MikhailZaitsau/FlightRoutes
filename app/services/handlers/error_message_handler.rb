# frozen_string_literal: true

module Handlers
  class ErrorMessageHandler < Core::Service
    def call(error_message = nil, status = :bad_request)
      render json: { route: nil, status: 'FAIL', distance: 0, error_message: },
             status:
    end
  end
end

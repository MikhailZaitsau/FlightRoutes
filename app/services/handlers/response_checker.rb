# frozen_string_literal: true

module Handlers
  class ResponseChecker < Core::Service
    def call(response)
      response.code == 200 &&
        JSON.parse(response)['meta'] &&
        !JSON.parse(response)['meta']['count'].zero?
    end
  end
end

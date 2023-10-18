# frozen_string_literal: true

require 'dry/monads/result'
require 'dry/monads/try'
require 'dry/monads/do'
require 'dry/monads/do/all'

module Core
  class Service
    include Dry::Monads::Try::Mixin
    include Dry::Monads::Result::Mixin
    include Dry::Monads::Do::All

    def call(*)
      raise NotImplementedError
    end
  end
end

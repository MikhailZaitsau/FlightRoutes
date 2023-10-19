class FlightNumber < ApplicationRecord
  has_many :legs, dependent: :destroy
end

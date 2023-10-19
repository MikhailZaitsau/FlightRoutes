class FlightNumber < ApplicationRecord
  validates :flight_number, presence: true, uniqueness: true, length: { in: 6..7 }
  has_many :legs, dependent: :destroy
end

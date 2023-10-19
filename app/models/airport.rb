class Airport < ApplicationRecord
    validates :iata, presence: true, uniqueness: true, length: { is: 3 }
end

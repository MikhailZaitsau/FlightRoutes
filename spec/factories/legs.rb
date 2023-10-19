FactoryBot.define do
  factory :leg do
    departure { 'CDG' }
    arrival { 'LHR' }
    distance { 348 }
    flight_number_id { create(:flight_number)}
  end
end

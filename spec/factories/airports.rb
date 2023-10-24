# frozen_string_literal: true

FactoryBot.define do
  factory :airport do
    iata { Faker::Base.regexify(/^[A-Z]{3}$/) }
    city { Faker::Address.city }
    country { Faker::Address.country }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end

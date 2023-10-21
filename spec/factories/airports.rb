# frozen_string_literal: true

FactoryBot.define do
  factory :airport do
    iata { 'LHR' }
    city { 'LONDON' }
    country { 'UNITED KINGDOM' }
    latitude { 51.47750 }
    longitude { -0.46138 }
  end
end

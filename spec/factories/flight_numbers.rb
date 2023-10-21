# frozen_string_literal: true

FactoryBot.define do
  factory :flight_number do
    flight_number { Faker::Base.regexify(/^[A-Z0-9]{2,3}\d{4}$/) }
  end
end

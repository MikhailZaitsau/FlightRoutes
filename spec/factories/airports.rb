FactoryBot.define do
  factory :airport do
    iata { "MyString" }
    city { "MyString" }
    country { "MyString" }
    latitude { 1.5 }
    longitude { 1.5 }
  end
end

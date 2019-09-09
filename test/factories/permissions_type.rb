FactoryBot.define do
    factory :permissions_type do
        name { Faker::Movies::StarWars.character }
        description { Faker::Movies::StarWars.quote }
    end
end

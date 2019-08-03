FactoryBot.define do
    factory :new do
        title { Faker::Games::Witcher.witcher }
        text { Faker::Games::Witcher.quote }
    end
end

FactoryBot.define do
    factory :new do
        title {Faker::Witcher.witcher}
        text {Faker::Witcher.quote}
    end
end

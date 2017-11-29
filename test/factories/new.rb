FactoryBot.define do
    factory :news do
        title {Faker::Witcher.witcher}
        text {Faker::Witcher.quote}
    end
end

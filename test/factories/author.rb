FactoryBot.define do
    factory :author do
        name {Faker::FamilyGuy.character}
        biography {Faker::FamilyGuy.quote}
        tag {build(:tag_author)}
        website {Faker::Internet.url}
    end
end

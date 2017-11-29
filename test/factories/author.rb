FactoryBot.define do
    factory :author do
        name {Faker::FamilyGuy.character}
        biography {Faker::FamilyGuy.quote}
        tag {build(:tag_author)}
        websites {[Faker::Internet.url]}
    end
end

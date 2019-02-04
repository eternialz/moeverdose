FactoryBot.define do
    factory :author do
        name {Faker::TvShows::FamilyGuy.character}
        biography {Faker::TvShows::FamilyGuy.quote}
        association :tag, factory: :tag_author
        website {Faker::Internet.url}
    end
end

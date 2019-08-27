FactoryBot.define do
    factory :author do
        name { TagService.sanitize(Faker::TvShows::FamilyGuy.character) }
        biography { Faker::TvShows::FamilyGuy.quote }
        tag { Tag.new(type: :author, aliases: [Alias.new(main: true, name: TagService.sanitize(name).to_s)]) }
        website { Faker::Internet.url }
    end
end

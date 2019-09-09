FactoryBot.define do
    factory :alias do
        name { TagService.sanitize(Faker::Games::Pokemon.name) }
        main { false }
    end

    factory :main_alias, class: 'Alias' do
        name { TagService.sanitize(Faker::Games::Pokemon.move) }
        main { true }
    end
end

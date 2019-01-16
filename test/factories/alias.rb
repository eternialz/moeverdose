FactoryBot.define do
    factory :alias do
        name {Faker::Pokemon.name}
        main {false}
    end

    factory :main_alias, class: "Alias" do
        name {Faker::Pokemon.move}
        main {true}
    end
end

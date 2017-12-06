FactoryBot.define do
    factory :tag_content, class: 'Tag' do
        names {[Faker::Cat.breed.downcase.gsub(' ', '_')]}
        type {:content}
    end

    factory :tag_character, class: 'Tag' do
        names {[Faker::Cat.name.downcase.gsub(' ', '_')]}
        type {:character}
    end

    factory :tag_author, class: 'Tag' do
        names {[Faker::Cat.registry.downcase.gsub(' ', '_')]}
        type {:author}
    end
end

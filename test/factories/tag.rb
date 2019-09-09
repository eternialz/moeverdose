FactoryBot.define do
    to_create do |instance|
        raise 'Invalid record: ' + instance.errors.full_messages.join(', ') unless instance.save
    end

    factory :tag_content, class: 'Tag' do
        type { 'content' }
        after(:build) do |tag|
            tag.aliases << create(:main_alias)
            tag.aliases << create(:alias)
        end
    end

    factory :tag_character, class: 'Tag' do
        type { 'character' }
        after(:build) do |tag|
            tag.aliases << create(:main_alias)
            tag.aliases << create(:alias)
        end
    end

    factory :tag_author, class: 'Tag' do
        type { 'author' }
        after(:build) do |tag|
            tag.aliases << create(:main_alias)
            tag.aliases << create(:alias)
        end
    end

    factory :tag_copyright, class: 'Tag' do
        type { 'copyright' }
        after(:build) do |tag|
            tag.aliases << create(:main_alias)
            tag.aliases << create(:alias)
        end
    end
end

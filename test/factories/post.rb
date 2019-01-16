require_relative '../factory_helpers'
require 'digest/md5'
FactoryBot.define do
    factory :post do
        sequence(:number, 1)
        title {Faker::Lovecraft.deity}
        source {Faker::ElderScrolls.race}
        description {Faker::DrWho.quote}
        width {500}
        height {500}
        md5 {SecureRandom.hex(32)}
        post_image {sample_file}

        after(:build) do |post|
            post.tags << create(:tag_content)
            post.tags << create(:tag_character)
            post.tags << create(:tag_author)
        end
    end
end

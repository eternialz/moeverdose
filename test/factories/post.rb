FactoryBot.define do
    factory :post do
        sequence(:number, 1)
        title { Faker::Books::Lovecraft.deity }
        source { Faker::Games::ElderScrolls.race }
        description { Faker::TvShows::DrWho.quote }
        width { 500 }
        height { 500 }
        md5 { SecureRandom.hex(32) }
        post_image { sample_file }
        created_at { Time.now.to_date }

        after(:build) do |post|
            post.tags << create(:tag_content)
            post.tags << create(:tag_character)
            post.tags << create(:tag_author)
        end
        
        factory :post_reported do
            after(:build) do |post|
                post.reports << build(:report)
            end
        end
    end
end

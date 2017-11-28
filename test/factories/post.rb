require_relative '../factory_helpers'
require 'digest/md5'
FactoryBot.define do
    factory :post do
        sequence(:number, 1)
        title {Faker::Lovecraft.deity}
        source {Faker::ElderScrolls.race}
        description {Faker::DrWho.quote}
        post_image {sample_file}
        width 500
        height 500

        after(:build) do |post|
            post.md5 = Digest::MD5.file(post.post_image.queued_for_write[:original].path).hexdigest
        end
    end
end




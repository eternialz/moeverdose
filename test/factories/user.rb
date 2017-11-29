require_relative '../factory_helpers'
FactoryBot.define do
    factory :user do
        email {Faker::Internet.email}
        sequence(:name) do |n|
            "#{Faker::HitchhikersGuideToTheGalaxy.character}#{n}"
        end
        password "password"
        association :level, factory: :level

        factory :admin, class: 'User' do
            role :administrator
        end

        factory :user_with_post, class: 'User' do
            after(:build) do |user|
                user.posts << build(:post)
            end

            after(:create) do |user|
                user.posts.each do |p|
                    p.save
                end
            end
        end
    end
end

FactoryBot.define do
    factory :user do
        email { Faker::Internet.email }
        sequence(:name) do |n|
            "#{Faker::Movies::Hobbit.character.split(' ').first}#{n}"
        end
        password { 'password' }
        biography { 'test' }
        association :level, factory: :level
        role { 'user' }
        confirmed_at { Time.zone.now }

        factory :admin, class: 'User' do
            role { 'administrator' }
        end

        factory :user_with_post, class: 'User' do
            after(:build) do |user|
                user.posts << build(:post)
            end

            after(:create) do |user|
                user.posts.each(&:save)
            end
        end

        factory :user_banned, class: 'User' do
            banned { true }
        end

        factory :user_reported, class: 'User' do
            report { true }
        end
    end
end

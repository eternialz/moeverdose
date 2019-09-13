FactoryBot.define do
    factory :comment do
        user { build(:user_with_post) }
        post { user.posts.first }
        text { Faker::Movies::Hobbit.quote[0..200] }

        factory :comment_reported, class: 'Comment' do
            after(:build) do |comment|
                comment.reports << build(:report)
            end
        end

        before(:create) do |comment|
            comment.user.save
            comment.user.posts.each(&:save)
        end
    end
end

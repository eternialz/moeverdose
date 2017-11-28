FactoryBot.define do
    factory :comment do
        user {build(:user_with_post)}
        post {user.posts.first}
        text {Faker::Hobbit.quote[0..200]}

        factory :comment_reported, class: 'Comment' do
            report {true}
            report_user {comment.user}
            report_reason {Faker::LeagueOfLegends.quote}
        end

        before(:create) do |comment|
            comment.user.save
            comment.user.posts.each do |p|
                p.save
            end
        end
    end
end

FactoryBot.define do
    factory :comment do
        user {build(:user_with_post)}
        post {user.posts.first}
        text {Faker::Movies::Hobbit.quote[0..200]}

        factory :comment_reported, class: 'Comment' do
            report {true}
            report_user {user}
            report_reason {Faker::Games::LeagueOfLegends.quote}
        end

        before(:create) do |comment|
            comment.user.save
            comment.user.posts.each do |p|
                p.save
            end
        end
    end
end

FactoryBot.define do
    sequence :level_rank, 0
    factory :level do
        name {Faker::BackToTheFuture.character}
        rank {generate :level_rank}
        max_exp {[50..100].sample}

        factory :level_final, class: 'Level' do
            final true
        end
    end
end


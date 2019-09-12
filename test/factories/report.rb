FactoryBot.define do
    factory :report do
        reason { Faker::Books::Lovecraft.sentence }
        user { build(:user_with_post) }
    end
end


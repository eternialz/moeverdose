require 'test_helper'

class UserServiceTest < ActiveSupport::TestCase
    setup do
        FactoryBot.rewind_sequences
        Level.destroy_all
        @user = create(:user)
        create(:level, rank: 1)
        create(:level_final, rank: 2)
        @user.exp = 0
        @user.upload_count = 0
        @user.save
    end

    test 'update_level' do
        UserService.update_level(@user)

        assert_equal 1, @user.upload_count
        assert_equal 1, @user.exp
        assert_equal 0, @user.level.rank
        assert @user.persisted?
    end

    test 'update_level_with_level_increase' do
        @user.exp = @user.level.max_exp

        assert_difference -> { @user.level.rank }, 1 do
            UserService.update_level(@user)
        end

        assert @user.persisted?
    end
end

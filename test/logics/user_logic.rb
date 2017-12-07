require 'test_helper'

class UserLogicTest < ActiveSupport::TestCase

    setup do
        @user = UserLogic.new(create(:user))
        create(:level_final, rank: 1)
        @user.exp = 0
        @user.upload_count = 0
        @user.save
    end

    test 'update_level' do
        @user.update_level

        assert_equal 1, @user.upload_count
        assert_equal 1, @user.exp
        assert_equal 0, @user.level.rank
        assert @user.persisted?
    end
end

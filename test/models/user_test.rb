require 'test_helper'

class UserTest < ActiveSupport::TestCase
    test 'Can make new user' do
        user = User.new

        assert user
    end
end

require 'test_helper'

class UserTest < ActiveSupport::TestCase
    test 'Can make new user' do
        user = new User

        assert user
    end
end

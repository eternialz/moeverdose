require 'test_helper'

class UserRegistrationsControllerTest < ActionDispatch::IntegrationTest
    setup do
    end

    test 'Guest can register' do
        create(:user)

        params = {
            user: {
                name: 'abcdef',
                email: 'abcdef@gmail.com',
                password: '123456',
                password_confirmation: '123456'
            }
        }

        assert_difference -> { User.count }, 1 do
            post user_registration_path, params: params
        end
        assert_redirected_to root_path
    end
end

require 'test_helper'

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    setup do
        @user = create(:user)
        @admin = create(:admin)
        sign_in @admin
    end

    test 'index' do
        get admin_users_path
        assert_response :success
    end

    test 'show' do
        get admin_user_path(@user)
        assert_response :success
    end

    test 'edit' do
        get edit_admin_user_path(@admin)
        assert_response :success
    end

    test 'update_role' do
        user = create(:user)
        params = {
            user: {
                role: 'administrator'
            }
        }
        patch admin_user_path(user), params: params
        user.reload
        assert_equal 'administrator', user.role
        assert_redirected_to admin_users_path
    end

    test 'unreport' do
        user = create(:user_reported)
        assert_difference -> { Report.count }, -1 do
            patch admin_user_unreport_path(user)
        end
        user.reload
        assert_equal user.warnings, []
        assert_redirected_to admin_users_path
    end

    test 'ban' do
        user = create(:user)
        patch admin_user_ban_path(user)
        user.reload
        assert user.banned
        assert_response :redirect
        assert_equal @response.headers['X-Xhr-Redirect-Url'], admin_users_path
    end

    test 'do not ban staff' do
        user = create(:admin)
        patch admin_user_ban_path(user)
        user.reload
        assert_not user.banned
        assert_response :redirect
        assert_equal @response.headers['X-Xhr-Redirect-Url'], admin_users_path
    end

    test 'unban' do
        user = create(:user_banned)
        patch admin_user_ban_path(user)
        user.reload
        assert_not user.banned
        assert_response :redirect
        assert_equal @response.headers['X-Xhr-Redirect-Url'], admin_users_path
    end
end

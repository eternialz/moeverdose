require 'test_helper'

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    setup do
        @user = create(:user)
        @admin = create(:admin)
    end

    test "can't_access_when_not_logged" do
        get admin_dashboard_path

        assert_redirected_to new_user_session_path
    end

    test "can't_access_when_not_admin"do
        sign_in @user

        get admin_dashboard_path

        assert_redirected_to root_path
    end

    test 'index' do
        sign_in @admin

        get admin_dashboard_path

        assert_response :success
    end

    test 'stats' do
        sign_in @admin

        get admin_stats_path

        assert_response :success
    end

end

require 'test_helper'

class TeamsControllerTest < ActionDispatch::IntegrationTest
    setup do
        @admin = create(:admin)
    end

    test 'Show index' do
        get teams_path

        @users = @controller.instance_variable_get(:@users)

        assert_not @users.empty?
        assert_response :success
        assert_select 'title', 'Team - Moeverdose'
    end
end

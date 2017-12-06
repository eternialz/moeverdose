require 'test_helper'
require 'config_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
    include ConfigHelper

    test 'Home Page' do
        get root_path
        assert_response :success
        assert_select 'title', site_name
    end
end

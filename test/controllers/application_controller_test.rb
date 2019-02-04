require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest

    test 'Home Page' do
        get root_path
        assert_response :success
    end
end

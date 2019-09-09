require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
    setup do
        5.times { create(:tag_content) }
        5.times { create(:tag_character) }
        5.times { create(:tag_author) }
        5.times { create(:tag_copyright) }
    end

    test 'Home Page' do
        get root_path
        assert_response :success
    end
end

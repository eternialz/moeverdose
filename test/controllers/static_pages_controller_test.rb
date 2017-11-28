require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
    test "Sample Static Help Page" do
        page = "index"
        get static_help_page_path(page)

        assert_response 200
        assert_select "title", "Help - " + page.capitalize + " - Moeverdose"
    end

    test "Sample Static Page" do
        page = "about"
        get static_page_path(page)

        assert_response 200
        assert_select "title", page.capitalize + " - Moeverdose"
    end
end

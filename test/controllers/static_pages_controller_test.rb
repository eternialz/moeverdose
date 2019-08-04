require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
    test 'Sample Static wiki Page' do
        page = 'index'
        get wiki_static_page_path(page)

        assert_response 200
        assert_select 'title', "Wiki - #{page.capitalize} - Moeverdose"
    end

    test 'Sample Static Page' do
        page = 'about'
        get static_page_path(page)

        assert_response 200
        assert_select 'title', page.capitalize + ' - Moeverdose'
    end
end

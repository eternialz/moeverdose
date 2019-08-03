require 'test_helper'

class NewsControllerTest < ActionDispatch::IntegrationTest
    setup do
        @news = create(:new)
    end

    test 'Show news' do
        get news_path(@news)

        assert_response :success
        assert_select 'title', @news.title + ' - Moeverdose'
    end
end

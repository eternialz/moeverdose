require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest

    setup do
        @user = create(:user_with_post)
    end

    test 'all_posts_index' do
        get posts_path

        assert_response :success

        assert_select 'title', 'All posts - Moeverdose'
    end
end

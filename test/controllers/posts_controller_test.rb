require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest

    setup do
        @user = create(:user_with_post)
        @post = @user.posts.first
    end

    test 'all_posts_index' do
        get posts_path

        assert_response :success

        assert_select 'title', 'All posts - Moeverdose'
    end

    test 'query_index' do
        10.times do
            create(:post, user: @user)
        end

        tag = @post.tags.first
        query = tag.names.first
        params = {
            query: query
        }

        get posts_path, params: params
        assert_response :success

        posts = @controller.instance_variable_get(:@posts)
        posts.each do |post|
            assert post.tags.include?(tag)
        end
    end
end

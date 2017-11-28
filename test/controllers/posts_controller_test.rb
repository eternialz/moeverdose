require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

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

    test 'post not found' do
        get post_path(-1)
        assert_response 404
    end

    test 'random post' do
        get random_path
        assert_response 302
    end

    test 'create post' do
        post_count = Post.count
        sign_in @user

        file = sample_path()
        uploaded_file = Rack::Test::UploadedFile.new(file, 'image/png')

        image = fixture_file_upload(sample_path(), 'image/png')
        binding.pry

        post posts_path(
            post: {
                file: image
            }
        )

        assert_equal Post.count, post_count + 1
        assert redirect_to post_path(post)
    end

    test 'Can\'t create post unlogged' do
        post_count = Post.count

        assert_equal Post.count, post_count
        assert redirect_to post_path(post)
    end

    test 'update post' do
        assert redirect_to post_path(post)
    end
end

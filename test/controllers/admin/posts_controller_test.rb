require 'test_helper'

class Admin::PostsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    setup do
        @admin = create(:admin)
        sign_in @admin
        @post = create(:user_with_post).posts.first
    end

    test 'admin index post' do
        get admin_posts_path
        assert_response :success
    end

    test 'admin show post' do
        get admin_post_path(@post)
        assert_response :success
    end

    test 'admin edit post' do
        get edit_admin_post_path(@post)
        assert_response :success
    end

    test 'admin destroy post' do
        @post = create(:user_with_post).posts.first

        assert_difference -> { Post.count }, -1 do
            delete admin_post_path(@post), params: { method: :delete }
        end

        assert_redirected_to admin_posts_path
    end

    test 'admin unreport post' do
        patch admin_post_unreport_path(@post)
        @post.reload

        assert_equal @post.reports, []

        assert_redirected_to admin_posts_path
    end

    test 'admin update post' do
        @post.tags = []
        @post.save

        params = {
            post: {
                title: '1',
                source: '2',
            }
        }

        patch admin_post_path(@post), params: params

        @updated_post = Post.find(@post.id)

        assert_equal @updated_post.title, params[:post][:title]
        assert_equal @updated_post.source, params[:post][:source]
        assert_redirected_to admin_post_path(@post)
    end
end

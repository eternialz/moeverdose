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

        assert_not @post.report
        assert @post.report_user.nil?
        assert @post.report_reason.blank?

        assert_redirected_to admin_posts_path
    end
end

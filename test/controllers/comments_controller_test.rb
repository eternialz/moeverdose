require 'test_helper'
require 'config_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers
    include ConfigHelper

    test 'Create Comment' do
        user = create(:user_with_post)
        sign_in user

        post = user.posts.first

        comment_count = Comment.count

        post post_comments_path(post.number, comment: { text: Faker::Movies::Hobbit.quote[0..max_comment_length] })

        assert_equal comment_count + 1, Comment.count
        assert_redirected_to post_path(post.number)
    end

    test "Can't Create Comment Unlogged" do
        user = create(:user_with_post)

        post = user.posts.first

        comment_count = Comment.count

        post post_comments_path(post.number, comment: { text: Faker::Movies::Hobbit.quote[0..max_comment_length] })

        assert_equal Comment.count, comment_count
        assert_redirected_to new_user_session_path
    end

    test 'Report Comment' do
        comment = create(:comment)
        user = create(:user)

        post = comment.post

        sign_in user

        patch comment_report_path(post.number, comment)

        assert Comment.find(comment.id).report?

        assert_redirected_to post_path(post.number)
    end

    test "Can't Report Comment Unlogged" do
        comment = create(:comment)
        create(:user)

        post = comment.post

        patch comment_report_path(post.number, comment)

        assert_not Comment.find(comment.id).report?
        assert_redirected_to new_user_session_path
    end
end

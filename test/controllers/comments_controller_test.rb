require 'test_helper'
require 'config_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers
    include ConfigHelper

    setup do
        @user = create(:user_with_post)
    end

    test 'Create Comment' do
        sign_in @user

        post = @user.posts.first

        assert_difference -> { Comment.count }, 1 do
            post post_comments_path(post.number, comment: { text: Faker::Movies::Hobbit.quote[0..max_comment_length] })
        end
        assert_redirected_to post_path(post.number)
    end

    test 'Create comment with post link' do
        sign_in @user

        post = @user.posts.first

        assert_difference -> { Comment.count }, 1 do
            post post_comments_path(post.number, comment: { text: "You should check ##{post.number} too!" })
        end

        updated_post = Post.find(post.id)

        assert updated_post.comments.last.text.include? post_path(id: updated_post.number)
        assert_redirected_to post_path(post.number)
    end

    test 'Create comment with user link' do
        sign_in @user

        post = @user.posts.first

        assert_difference -> { Comment.count }, 1 do
            post post_comments_path(post.number, comment: { text: "You should check @#{@user.name}'s profile." })
        end

        updated_post = Post.find(post.id)

        assert updated_post.comments.last.text.include? user_path(id: @user.name)
        assert_redirected_to post_path(post.number)
    end

    test 'Create comment with spoiler' do
        sign_in @user

        post = @user.posts.first

        assert_difference -> { Comment.count }, 1 do
            post post_comments_path(post.number, comment: { text: '[spoiler]They die at the end.[/spoiler]' })
        end

        updated_post = Post.find(post.id)

        assert updated_post.comments.last.text.include? '<input type="checkbox">'
        assert_redirected_to post_path(post.number)
    end

    test "Can't create Comment longer than the max autorised" do
        sign_in @user

        post = @user.posts.first

        comment_count = Comment.count

        text = Faker::Movies::Hobbit.quote
        text += Faker::Movies::Hobbit.quote until text.length > max_comment_length

        post post_comments_path(post.number, comment: { text: text })

        assert_equal comment_count, Comment.count
        assert_redirected_to post_path(post.number)
    end

    test "Can't Create Comment Unlogged" do
        post = @user.posts.first

        comment_count = Comment.count

        post post_comments_path(post.number, comment: { text: Faker::Movies::Hobbit.quote[0..max_comment_length] })

        assert_equal Comment.count, comment_count
        assert_redirected_to new_user_session_path
    end

    test 'Access Report Page' do
        comment = create(:comment)
        post = comment.post
        sign_in @user

        get new_comment_report_path(post.number, comment)
        assert_response :success
    end

    test 'Do Not Access Report Page Unlogged' do
        comment = create(:comment)
        post = comment.post

        get new_comment_report_path(post.number, comment)
        assert_redirected_to new_user_session_path
    end

    test 'Report Comment' do
        comment = create(:comment)
        post = comment.post
        sign_in @user

        params = {
            report: {
                reason: Faker::Books::Lovecraft.sentence
            }
        }
        
        assert_difference -> { Report.count }, 1 do
            post comment_report_path(post.number, comment), params: params
        end

        assert_equal Comment.find(comment.id).reports.size, 1

        assert_redirected_to post_path(post.number)
    end

    test "Can't Report Comment Unlogged" do
        comment = create(:comment)
        create(:user)

        params = {
            report: {
                reason: Faker::Books::Lovecraft.sentence
            }
        }

        post = comment.post

        post comment_report_path(post.number, comment), params: params

        assert_equal Comment.find(comment.id).reports, []
        assert_redirected_to new_user_session_path
    end
end

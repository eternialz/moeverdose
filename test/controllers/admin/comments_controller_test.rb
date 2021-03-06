require 'test_helper'

module Admin
    class CommentsControllerTest < ActionDispatch::IntegrationTest
        include Devise::Test::IntegrationHelpers

        setup do
            @admin = create(:admin)
            sign_in @admin
            @comment = create(:comment_reported)
        end

        test 'index' do
            get admin_comments_path
            assert_response :success
        end

        test 'show' do
            get admin_comment_path(@comment)
            assert_response :success
        end

        test 'destroy' do
            assert_difference -> { Comment.count }, -1 do
                assert_difference -> { Report.count }, -1 do
                    delete admin_comment_path(@comment)
                end
            end
            assert_redirected_to admin_comments_path
        end

        test 'unreport' do
            assert_difference -> { Report.count }, -1 do
                patch admin_comment_unreport_path(@comment)
            end
            @comment.reload

            assert_equal @comment.reports, []

            assert_redirected_to admin_comments_path
        end
    end
end

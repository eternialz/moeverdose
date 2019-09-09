require 'test_helper'

class UserServiceTest < ActiveSupport::TestCase
    setup do
        @last_post = create(:user_with_post).posts.first
    end

    test 'Post number assignation' do
        @new_post = Post.new

        PostService.assign_id(@new_post)

        assert_equal @last_post.number + 1, @new_post.number
    end

    test 'Post number first assignation' do
        Post.destroy_all

        @new_post = Post.new

        PostService.assign_id(@new_post)

        assert_equal 1, @new_post.number
    end
end

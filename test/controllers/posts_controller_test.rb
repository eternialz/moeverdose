require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest

    setup do
        @user = create(:user_with_post)

    end

    test 'index' do
        assert true

    end
end

require 'config_helper'

class AuthorsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers
    include ConfigHelper

    setup do
        @author = create(:author)
        @user = create(:user_with_post)
        @post = @user.posts.first
    end

    test 'author index' do
        get authors_path

        assert_response :success
        assert_select 'title', 'All Authors - Moeverdose'
    end

    test 'show author' do
        get author_path(@author)

        assert_response :success
        assert_select 'title', @author.name + "'s author page - Moeverdose"
    end

    test 'edit author' do
        sign_in @user

        get edit_author_path(@author)

        assert_response :success
        assert_select 'title', "Edit " + @author.name + "'s author page - Moeverdose"
    end

    test 'Can\'t edit author unlogged' do
        get edit_author_path(@author)

        assert_redirected_to new_user_session_path
    end

    test 'update author' do
        sign_in @user

        author_params = {
            name: Faker::FamilyGuy.character + @author.name,
            biography: Faker::FamilyGuy.quote + @author.name,
        }

        website_count = @author.websites.count

        patch author_path(
            @author,
            author: author_params,
            websites: Faker::Internet.url + " " + @author.websites.join(" ")
        )

        @updated_author = Author.find(@author)
        @updated_tag = @updated_author.tag

        assert_not_equal @updated_author.name, @author.name
        assert_not_equal @updated_author.name, @author.name
        assert_not_equal @updated_author.websites.count, website_count
        assert_equal @author.tag.names[0], @updated_tag.names.last
        assert_equal @updated_author.name.downcase.tr(' ', '_'), @updated_tag.names[0]
    end

    test 'Can\'t update author unlogged' do

        assert true
    end
end

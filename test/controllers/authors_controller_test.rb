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
        assert_select 'title', 'Edit ' + @author.name + "'s author page - Moeverdose"
    end

    test 'Can\'t edit author unlogged' do
        get edit_author_path(@author)

        assert_redirected_to new_user_session_path
    end

    test 'update author' do
        sign_in @user

        author_params = {
            name: Faker::TvShows::FamilyGuy.character + @author.name,
            biography: Faker::TvShows::FamilyGuy.quote + @author.name
        }

        old_name = @author.tag.name

        patch author_path(
            @author,
            author: author_params,
            website: Faker::Internet.url
        )

        @updated_author = Author.find(@author.id)
        @updated_tag = @updated_author.tag

        assert_not_equal @updated_author.name, @author.name
        assert_equal @updated_author.name.downcase.tr(' ', '_'), @updated_tag.name
        assert_includes @updated_tag.names, old_name
    end

    test 'Can\'t update author unlogged' do
        author_params = {
            name: Faker::TvShows::FamilyGuy.character,
            biography: Faker::TvShows::FamilyGuy.quote
        }

        patch author_path(
            @author,
            author: author_params,
            website: Faker::Internet.url
        )

        @updated_author = Author.find(@author.id)
        assert_equal @updated_author.name, @author.name
        assert_redirected_to new_user_session_path
    end
end

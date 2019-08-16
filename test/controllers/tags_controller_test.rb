require 'test_helper'

class TagsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    setup do
        @tag_content = create(:tag_content)
        @tag_character = create(:tag_character)
        @tag_author = create(:tag_author)

        11.times do
            create(:tag_content)
        end

        @user = create(:user)
    end

    test 'index_without_query' do
        get tags_path

        assert_response :success
        assert_select 'title', 'All Tags - Moeverdose'
    end

    test 'index_with_good_query' do
        params = {
            query: @tag_author.names.first
        }

        get tags_path, params: params
        @tags = @controller.instance_variable_get(:@tags)

        assert_response :success
        assert_not @tags.empty?
    end

    test 'index_with_items_per_page' do
        params = {
            items_per_page: 8
        }

        get tags_path, params: params
        @tags = @controller.instance_variable_get(:@tags)

        assert_response :success
        assert_not @tags.empty?
        assert @tags.size <= 8
    end

    test 'edit' do
        sign_in @user

        get edit_tag_path(@tag_content)

        assert_response :success
        assert_select 'title', "Edit tag #{@tag_content.names.first} - Moeverdose"
    end

    test 'update_with_non_unique_names' do
        sign_in @user

        params = {
            names: 'malotru kawaii banane malotru banane malotru kawaii'
        }

        patch tag_path(@tag_character), params: params

        @updated_tag = @controller.instance_variable_get(:@tag)

        assert_equal 4, @updated_tag.names.count
        assert_redirected_to tags_path
    end
end

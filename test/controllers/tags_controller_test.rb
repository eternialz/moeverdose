require 'test_helper'

class TagsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    setup do
        @tag_content = create(:tag_content)
        @tag_character = create(:tag_character)
        @tag_author = create(:tag_author)
        user = create(:user)
        sign_in user
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

    test 'edit' do
        get edit_tag_path(@tag_content)

        assert_response :success
        assert_select 'title', "Edit tag #{@tag_content.names.first} - Moeverdose"
    end
    #     test 'update_with_unique_names' do
    #
    #         params = {
    #             names: "banane malotru kawaii"
    #         }
    #
    #         assert_difference -> {@tag_character.names.count}, 3 do
    #             patch tag_path(@tag_character), params: params
    #             @tag_character.reload
    #         end
    #
    #         assert_redirected_to tags_path
    #     end
    #
    #     test 'update_with_non_unique_names' do
    #         params = {
    #             names: "malotru kawaii banane malotru banane malotru kawaii"
    #         }
    #         assert_difference -> {@tag_character.names.count}, 3 do
    #             patch tag_path(@tag_character), params: params
    #             @tag_character.reload
    #         end
    #
    #         assert_redirected_to tags_path
    #     end
end

require 'test_helper'

class Admin::LevelsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    setup do
        @admin = create(:admin)
        sign_in @admin
        @level = create(:level_final)
    end

    test 'index' do
        get admin_levels_path
        assert_response :success
    end

    test 'new' do
        get new_admin_level_path
        assert_response :success
    end

    test 'edit' do
        get edit_admin_level_path(@level)
        assert_response :success
    end

    test 'create' do
        params = {
            level: {
                max_exp: 200,
                color: Faker::Color.hex_color,
                name: Faker::HarryPotter.character
            }
        }

        assert_difference -> {Level.count} do
            post admin_levels_path, params: params
        end

        assert_redirected_to admin_levels_path
        @level.reload

        @new_level = @controller.instance_variable_get(:@level)

        assert @new_level.final?
        assert_not @level.final?
        assert_equal @level.rank + 1, @new_level.rank
    end

    test 'update' do
        params = {
            level: {
                name: "banane"
            }
        }
        assert_no_difference -> {Level.count} do
            patch admin_level_path(@level), params: params
        end

        assert_redirected_to admin_levels_path
    end
end

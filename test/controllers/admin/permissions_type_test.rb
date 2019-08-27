require 'test_helper'

class Admin::NewsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    setup do
        @admin = create(:admin)
        sign_in @admin
        @permissions_type = create(:permissions_type)
    end

    test 'admin index persmissions type' do
        get admin_permissions_types_path
        assert_response :success
    end

    test 'admin new persmissions type' do
        get new_admin_permissions_type_path
        assert_response :success
    end

    test 'admin create persmissions type' do
        params = {
            permissions_type: {
                name: '1',
                description: '2'
            }
        }

        assert_difference -> { PermissionsType.count } do
            post admin_permissions_types_path, params: params
        end

        @new_permissions_type = @controller.instance_variable_get(:@permissions_type)

        assert_redirected_to admin_permissions_types_path

        assert_equal @new_permissions_type.name, params[:permissions_type][:name]
    end

    test 'admin destroy persmissions type' do
        @permissions_type = create(:permissions_type)
        assert_difference -> { PermissionsType.count }, -1 do
            delete admin_permissions_type_path @permissions_type, params: { method: :delete }
        end

        assert_xhr_redirected_to admin_permissions_types_path
    end
end

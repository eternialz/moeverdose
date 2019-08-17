require 'test_helper'

class Admin::NewsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    setup do
        @admin = create(:admin)
        sign_in @admin
        @new = create(:new)
    end

    test 'admin index news' do
        get admin_news_index_path
        assert_response :success
    end

    test 'admin show news' do
        get admin_news_path(@new)
        assert_response :success
    end

    test 'admin new new' do
        get new_admin_news_path
        assert_response :success
    end

    test 'admin edit new' do
        get edit_admin_news_path(@new)
        assert_response :success
    end

    test 'admin create new' do
        params = {
            news: {
                title: '1',
                text: '2'
            }
        }

        assert_difference -> { New.count } do
            post admin_news_index_path, params: params
        end

        @new_new = @controller.instance_variable_get(:@new)

        assert_redirected_to admin_news_path(@new_new)

        assert_equal @new_new.title, params[:news][:title]
    end

    test 'admin update new' do
        params = {
            news: {
                title: '3'
            }
        }

        assert_no_difference -> { New.count } do
            patch admin_news_path(@new), params: params
        end

        assert_redirected_to admin_news_path(@new)

        @new_new = @controller.instance_variable_get(:@new)

        assert_equal @new_new.title, params[:news][:title]
    end

    test 'admin destroy new' do
        @new = create(:new)
        assert_difference -> { New.count }, -1 do
            delete admin_news_path @new, params: { method: :delete }
        end

        assert_redirected_to admin_news_index_path
    end
end

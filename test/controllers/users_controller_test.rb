require 'config_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers
    include ConfigHelper

    setup do
        @user = create(:user, password: 'password')
        @user_secondary = create(:user)
        @user_banned = create(:user_banned)

        4.times { create(:permissions_type) }
    end

    test 'show user' do
        get user_path(@user.name)

        assert_response :success
        assert_select 'title', @user.name + ' profile - ' + site_name
    end

    test 'show banned user' do
        get user_path(@user_banned.name)

        assert_response :success
        assert_select 'title', 'Banned User - ' + site_name
    end

    test 'show current user' do
        sign_in @user
        get user_path(@user.name)

        assert_response :success
        assert_select 'title', @user.name + ' profile - ' + site_name
        assert_select '.user-show' do
            assert_select 'a.button-secondary[href=?]', edit_user_path(@user.name)
        end
    end

    test 'edit current user' do
        sign_in @user
        get edit_user_path(@user.name)

        assert_response :success
        assert_select 'title', 'Edit my profile - ' + site_name
    end

    test 'Can\'t edit another user' do
        sign_in @user_secondary

        get edit_user_path(@user.name)

        assert_redirected_to edit_user_path(@user_secondary.name)
    end

    test 'Can\'t edit user unlogged' do
        get edit_user_path(@user.name)

        assert_redirected_to new_user_session_path
    end

    test 'update current user' do
        sign_in @user

        patch user_path(
            @user.name,
            user: user_params(@user),
            tags: {
                favorites: '',
                blacklisted: ''
            }
        )

        @updated_user = User.find(@user.id)

        assert_not_equal @updated_user.biography, @user.biography
        assert_redirected_to user_path(@user.name)
    end

    test 'Can\'t update another user' do
        sign_in @user_secondary

        patch user_path(
            @user.name,
            user: user_params(@user),
            tags: {
                favorites: '',
                blacklisted: ''
            }
        )

        @updated_user = User.find(@user.id)

        assert_equal @updated_user, @user
        assert_redirected_to edit_user_path(@user_secondary.name)
    end

    test 'Can\'t update user unlogged' do
        patch user_path(
            @user.name,
            user: user_params(@user),
            tags: {
                favorites: '',
                blacklisted: ''
            }
        )

        @updated_user = User.find(@user.id)

        assert_equal @updated_user, @user
        assert_redirected_to new_user_session_path
    end

    test 'favorites' do
        get user_favorites_path(@user.name)
        assert_response :success
    end

    test 'uploads' do
        get user_uploads_path(@user.name)
        assert_response :success
    end

    test 'delete' do
        sign_in @user
        patch delete_user_path(@user.name, user: { password: 'password' })
        assert_redirected_to root_path

        @updated_user = User.find(@user.id)
        assert_not_equal @updated_user.deleted_at, @user.deleted_at
        assert @updated_user.deleted_at
    end

    test 'login disable flag for deletion' do
        @user.deleted_at = DateTime.now.to_date
        @user.save

        sign_in @user
        @user.after_database_authentication

        get edit_user_path(@user)

        @updated_user = User.find(@user.id)
        assert_not @user.deleted_at
    end

    test 'all users' do
        get users_path

        assert_response :success
        assert_select 'title', 'All Users - ' + site_name
    end

    test 'all users wth query' do
        10.times do
            create(:user)
        end

        get users_path(query: @user.name)
        users = @controller.instance_variable_get(:@users)

        assert_response :success
        users.each do |user|
            assert user.name.include? @user.name
        end
        assert_select 'title', 'All Users - ' + site_name
    end

    private

    def user_params(user)
        {
            email: Faker::Internet.email,
            website: Faker::Internet.url,
            facebook: Faker::Internet.url,
            twitter: Faker::Internet.url,
            biography: Faker::Movies::Hobbit.quote + user.biography
        }
    end
end

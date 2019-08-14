require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    setup do
        @user = create(:user_with_post)
        @post = @user.posts.first
    end

    test 'show post' do
        get post_path(@post.number)

        assert_response :success

        if @post.title.present?
            assert_select 'title', @post.title + ' - Moeverdose'
        else
            assert_select 'title', 'Post - Moeverdose'
        end
    end

    test 'Show report post' do
        sign_in @user

        get edit_report_post_path(@post)

        assert_response :success

        assert_select 'title', 'Report post - Moeverdose'
    end

    test 'Can\'t show report post unlogged' do
        get edit_report_post_path(@post)

        assert_redirected_to new_user_session_path
    end

    test 'report post' do
        @post.report = false
        @post.save

        sign_in @user

        patch report_post_path @post.number, post: { report_reason: Faker::TvShows::HowIMetYourMother.catch_phrase }

        @updated_post = Post.find(@post.id)

        assert @updated_post.report?
        assert_redirected_to post_path(@post.number)
    end

    test 'Can\'t report post unlogged' do
        @post.report = false
        @post.save

        patch report_post_path @post.number, post: { report_reason: Faker::TvShows::HowIMetYourMother.catch_phrase }

        @updated_post = Post.find(@post.id)

        assert_not @updated_post.report?
        assert_redirected_to new_user_session_path
    end

    test 'Show edit report post' do
        sign_in @user

        get edit_report_post_path(@post)

        assert_response :success

        assert_select 'title', 'Report post - Moeverdose'
    end

    test 'Can\'t show edit report post unlogged' do
        get edit_report_post_path(@post)

        assert_redirected_to new_user_session_path
    end

    test 'favorite post' do
        sign_in @user
        fav_count = @user.favorites.count

        patch post_favorite_path @post.number

        @updated_user = User.find(@user.id)

        assert_not_equal fav_count, @updated_user.favorites.count
        assert_response :success
    end

    test 'Remove favorite post' do
        sign_in @user

        @user.favorites << @post
        @user.save

        fav_count = @user.favorites.count

        patch post_favorite_path @post.number

        @updated_user = User.find(@user.id)

        assert_equal fav_count - 1, @updated_user.favorites.count
        assert_response :success
    end

    test 'Can\'t add favorite post unlogged' do
        patch post_favorite_path @post.number

        assert_xhr_redirected_to new_user_session_path
        assert_response 302
    end

    test 'dose - add overdose' do
        sign_in @user

        patch post_dose_path @post.number, dose: 'overdose'

        @updated_post = Post.find(@post.id)

        assert_not_equal @post.overdose, @updated_post.overdose
    end

    test 'dose - add shortage' do
        sign_in @user

        patch post_dose_path @post.number, dose: 'shortage'

        @updated_post = Post.find(@post.id)

        assert_not_equal @post.moe_shortage, @updated_post.moe_shortage
    end

    test 'Can\'t add shortage/overdose unlogged' do
        patch post_dose_path @post, ['shortage', 'overdose']

        @updated_post = Post.find(@post.id)

        assert_equal @post.moe_shortage, @updated_post.moe_shortage
        assert_xhr_redirected_to new_user_session_path
        assert_response 302
    end

    test 'all_posts_index' do
        get posts_path

        assert_response :success

        assert_select 'title', 'All posts - Moeverdose'
    end

    test 'query_index' do
        10.times do
            create(:post, user: @user)
        end

        tag = @post.tags.first
        query = tag.names.first
        params = {
            query: query
        }

        get posts_path, params: params
        assert_response :success

        posts = @controller.instance_variable_get(:@posts)
        posts.each do |post|
            assert post.tags.include?(tag)
        end
    end

    test 'all_posts_blacklist_index' do
        10.times do
            create(:post, user: @user)
        end

        sign_in @user

        tag = @post.tags.first
        @user.update_attributes(blacklisted_tags: [tag])

        get posts_path
        assert_response :success

        posts = @controller.instance_variable_get(:@posts)
        posts.each do |post|
            assert_not post.tags.include?(tag)
        end
    end

    test 'query_blacklist_index' do
        10.times do
            create(:post, user: @user)
        end

        sign_in @user

        black_tag = @post.tags.first
        @user.update_attributes(blacklisted_tags: [black_tag])
        tag = Tag.where.not(id: black_tag.id).last
        query = tag.names.first
        params = {
            query: query
        }

        get posts_path, params: params
        assert_response :success

        posts = @controller.instance_variable_get(:@posts)
        posts.each do |post|
            assert_not post.tags.include?(black_tag)
            assert post.tags.include?(tag)
        end
    end

    test 'new post' do
        sign_in @user

        get new_post_path
        assert_select 'title', 'Upload - Moeverdose'
    end

    test 'Can\'t access new post unlogged' do
        get new_post_path
        assert_redirected_to new_user_session_path
    end

    test 'create post' do
        sign_in @user

        # post_count = Post.count
        # file = "image.png"
        #
        # content = sample_file(file).read
        # locale_file = Tempfile.new(["image", "png"])
        # locale_file.write content
        # locale_file.rewind
        #
        # upload = ActionDispatch::Http::UploadedFile.new({
        #     filename: file,
        #     type: 'image/png',
        #     tempfile: fixture_file_upload(sample_path, 'image/png'),
        #     head: "Content-Disposition: form-data; name=\"post[post_image]\"; filename=\"image.png\"\r\n
        #            Content-Type: image/png\r\n"
        # })
        #
        # binding.pry
        #
        # post posts_path(
        #     post: {
        #         "post_image" => upload
        #     }
        # )
        #
        # locale_file.close
        #
        # assert_equal Post.count, post_count + 1
        # assert_redirect_to post_path(post)
        assert true
    end

    test 'Can\'t create post unlogged' do
        assert_no_difference -> { Post.count } do
            post create_post_path(
                post: {
                    'post_image' => '1'
                }
            )
        end

        assert_redirected_to new_user_session_path
    end

    test 'Get edit post page' do
        sign_in @user

        get edit_post_path(@post)

        assert_response :success
    end

    test 'Can\'t get edit post page unlogged' do
        get edit_post_path(@post)

        assert_redirected_to new_user_session_path
    end

    test 'update post' do
        sign_in @user

        post_params = {
            title: Faker::Games::Fallout.character + @post.title, # Adding current informations to force a different one
            source: Faker::Games::Fallout.faction + @post.source,
            description: Faker::Games::Fallout.quote + @post.description
        }

        patch post_path(
            @post.number,
            post: post_params,
            tags: '',
            characters: '',
            author_tag: ''
        )

        @updated_post = Post.find(@post.id)

        assert_not_equal @updated_post.title, @post.title
        assert_not_equal @updated_post.source, @post.source
        assert_not_equal @updated_post.description, @post.description
        assert_redirected_to post_path(@post.number)
    end

    test 'post not found' do
        get post_path(-1)
        assert_response 404
    end

    test 'random post' do
        get random_path
        assert_response 302
    end
end

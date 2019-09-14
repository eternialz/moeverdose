require 'test_helper'
require 'config_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers
    include ConfigHelper

    setup do
        @user = create(:user_with_post)
        @copyright_owner = create(:user)
        @unrelated_user = create(:user)
    end

    test "Visitor can't make a claim" do
        post claims_path params: { post_number: 2 }

        assert_redirected_to new_user_session_path
    end

    test 'Visitor can display new claim page' do
        get new_claim_path
        assert_response :success
    end

    test 'Logged user can make a claim' do
        sign_in @copyright_owner

        assert_difference -> { Claim.count }, 1 do
            post claims_path(params: { post_number: Post.first.number })
        end

        assert_redirected_to user_claims_path(@copyright_owner.name)
    end

    test "Logged user can't make a claim on post with his open claim" do
        sign_in @copyright_owner
        post = Post.first
        Claim.create(post: post, user: @copyright_owner, status: :open)

        assert_no_difference -> { Claim.count } do
            post claims_path(params: { post_number: Post.first.number })
        end

        assert_redirected_to new_claim_path
    end

    test 'Logged user can cancel his claim if it is open/accepted' do
        sign_in @copyright_owner
        post = Post.first
        Claim.create(post: post, user: @copyright_owner, status: [:open, :accepted].sample)

        patch cancel_claim_path(Claim.first)

        assert_redirected_to user_claims_path(@copyright_owner.name)
    end

    test 'User can dismiss/accept an open claim' do
        sign_in @user
        post = @user.posts.first
        Claim.create(post: post, user: @copyright_owner, status: :open)
    end

    test "User can't dismiss/accept a closed claim" do
        sign_in @user
        post = @user.posts.first
        Claim.create(post: post, user: @copyright_owner, status: [:accepted, :canceled, :dismissed].sample)
    end

    test "User who isn't the uploader or claimer can't display the claim in question" do
        sign_in @unrelated_user
        post = @user.posts.first
        Claim.create(post: post, user: @copyright_owner, status: Claim::Status.all.sample)

        get claim_path(Claim.first)

        assert_redirected_to user_claims_path(@unrelated_user.name)
    end
end

class ClaimsController < ApplicationController
    before_action :authenticate_user!, except: [:new]
    before_action :set_post, only: [:create]
    before_action :set_claim, except: [:new, :create]
    before_action :verify_user, only: [:show]

    def show
        render component 'claims/show'
    end

    def new
        @claim = Claim.new
        render component 'claims/new'
    end

    def create
        claim = Claim.where(post: @post, user: current_user, status: Claim::Status.hide_post).first
        if claim
            flash[:error] = 'You already claimed this post and it is currently hidden.'
        else
            claim = Claim.new(user: current_user, post: @post, status: :open)
        end

        if !flash[:error] && claim.save
            ClaimMailer.claimed(claim).deliver_later
            flash[:success] = 'Claim successfully created.'
            redirect_to user_claims_path(current_user.name)
        else
            flash[:error] ||= 'An error occured when creating your claim, please verify the informations you provided'
            redirect_to new_claim_path
        end
    end

    def decide_status
        redirect_to user_claims_path(current_user.name) if current_user != @claim.post.user

        change_claim_status(status_params) if @claim.open? && ['dismissed', 'accepted'].include?(status_params)
        ClaimMailer.unclaimed(@claim).deliver_later if @claim.dismissed? && @claim.user

        redirect_to user_claims_path(current_user.name)
    end

    def cancel
        redirect_to user_claims_path(current_user.name) if current_user != @claim.user

        change_claim_status(:canceled) if @claim.hide_post?

        redirect_to user_claims_path(current_user.name)
    end

    private

    def change_claim_status(status)
        @claim.status = status
        if @claim.save
            flash[:success] = 'Takedown notice status successfully changed.'
        else
            flash[:error] = "An error occured when trying to change the takedown notice's status."
        end
    end

    def set_post
        @post = Post.find_by(number: params[:post_number])
    end

    def set_claim
        @claim = Claim.includes(:user, post: :user).find(params[:id])
    end

    def status_params
        params.require(:status)
    end

    def verify_user
        redirect_to user_claims_path(current_user.name) unless [@claim.user, @claim.post.user].include? current_user
    end
end

class ClaimsController < ApplicationController
    before_action :authenticate_user!, except: [:new]
    before_action :set_post, only: [:create]
    before_action :set_claim, only: [:show, :change_status]
    before_action :verify_user, except: [:new, :create]

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
            claim = Claim.create(user: current_user, post: @post, status: :open)
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

    def change_status
        @claim.status = params.require(:status)
        @claim.save

        ClaimMailer.unclaimed(@claim).deliver_later
        flash[:success] = 'Claim state successfully changed.'
        redirect_to user_claims_path(current_user.name)
    end

    private

    def set_post
        @post = Post.find_by(number: params[:post_number])
    end

    def set_claim
        @claim = Claim.find(params[:id])
    end

    def verify_user
        [@claim.user, @claim.post.user].include? current_user
    end
end

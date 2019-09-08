class ClaimsController < ApplicationController
    before_action :authenticate_user!, except: [:new]
    before_action :set_default_index_values, only: [:index]
    before_action :set_post, only: [:claim]
    before_action :set_claim, only: [:show, :unclaim]

    def show
        render component 'claims/show'
    end

    def new
        @claim = Claim.new
        render component 'claims/new'
    end

    def index
        @claims = Kaminari.paginate_array(
            Claim.joins(:post).where(posts: { user: current_user })
        ).page(params[:page]).per(@items_per_page)
        render component 'claims/index'
    end

    def create
        @post.hidden = true
        claim = Claim.create(claimer: current_user, post: @post)

        ClaimMailer.claimed(claim).deliver_later
        flash[:success] = 'Claim successfully created.'
    end

    def destroy
        @claim.closed = true
        @claim.post.hidden = false
        @claim.save

        ClaimMailer.unclaimed(claim).deliver_later
        flash[:success] = 'Claim successfully removed.'
    end

    private

    def set_post
        @post = Post.find_by(number: [:id])
    end

    def set_claim
        @claim = Claim.find(params[:id])
    end
end

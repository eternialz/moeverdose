class PostsController < ApplicationController

  before_action :set_post, only: [:edit, :update, :show, :destroy]

  def show
    @comments = [1]
  end

  def index
    #@posts = Posts.all
  end

  def new
    #@post ||= Posts.new
  end

  def create

  end

  def destroy

  end

  def edit

  end

  def update

  end

  private
  def set_post
    if params[:id]
      #@question = FrequentlyAskedQuestion::Root.find(params[:id])
    end
  end

  def post_params
    params.require(:post).permit(
      :name
    )
  end

end

class PostsController < ApplicationController

  before_action :set_post, only: [:edit, :update, :show, :destroy]

  def show
    @comments = [1]
  end

  def index
    @posts = Post.all
  end

  def new
    @post ||= Post.new
  end

  def create
    @post = Post.new(post_params)

    dimensions = Paperclip::Geometry.from_file(@post.post_image.queued_for_write[:original].path)

    @post.width = dimensions.width
    @post.height = dimensions.height

    binding.pry

    if @post.save
      redirect_to post_path(@post)
    else
      new
    end
  end

  def destroy

  end

  def edit

  end

  def update
    if @post.save
      redirect_to post_path(@post)
    else
      new
    end
  end

  private
  def set_post
    if params[:id]
      @post = Post.find(params[:id])
    end
  end

  def post_params
    params.require(:post).permit(
      :title, :source, :post_image
    )
  end

end

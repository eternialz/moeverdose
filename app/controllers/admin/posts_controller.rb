class Admin::PostsController < Admin::BaseController
  before_action :set_post, except: [:index]

  def index
    @posts = Post.where(report: true)
  end

  def show  
  end

  def edit
  end

  def update
    @post.assign_attributes(post_params)
    if @post.save
      redirect_to admin_post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to admin_posts_path
  end

  protected
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(
      :title, :source, :report, :tags
    )
  end
end

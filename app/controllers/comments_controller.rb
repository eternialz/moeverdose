class CommentsController
  before_action :set_post

  def create
    @comment = @post.comments.create(params.require(:comment).permit(:text, :user))
    redirect_to post_path(@post)
  end

  def update
    @comment = @post.comments.find(params[:id])
    @comment.update_attributes(text: params[:text])
    redirect_to post_path(@post)
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    redirect_to post_path(@post)
  end
  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end

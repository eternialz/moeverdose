class CommentsController < ApplicationController
  before_action :set_post

  def create
    length = params[:comment][:text].length
    if length >= 2 && length <= 500
      @comment = Comment.create(params.require(:comment).permit(:text))
      @comment.user = current_user
      @post.comments << @comment
      @comment.post = @post
      @post.save
      @comment.save
    end
    redirect_to post_path(@post)
  end

  def report
    @comment = Comment.find(params[:comment_id])
    @comment.assign_attributes(params.require(:comment).permit(:report_reason))
    @comment.report = true
    @comment.report_user = current_user
    @comment.save
    redirect_to post_path(@post)
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end

class CommentsController < ApplicationController
    include ParserConcern

    before_action :set_post
    before_action :authenticate_user!

    def create
        @comment = Comment.create(params.require(:comment).permit(:text))
        length = @comment.text.length

        if length > 1 and length <= helpers.max_comment_length
            @comment.text = scan_comment(@comment.text) # This can add to the length, so validations are not used

            @comment.user = current_user
            @post.comments << @comment
            @comment.post = @post

            if @post.save && @comment.save
                flash[:success] = "Comment added."
            else
                flash[:error] = "Comment invalid."
            end
        else
            flash[:error] = "Comment invalid: please verify the length."
        end

        redirect_to post_path(@post.number)
    end

    def report
        @comment = Comment.find(params[:comment_id])
        @comment.report = true
        @comment.report_user = current_user
        @comment.save
        redirect_to post_path(@post.number)
    end

    private

    def set_post
        @post = Post.find_by(number: params[:post_id])
    end

    def scan_comment(text) # scan for comments, posts, and users referenced in comments
        text = scan_for_post(text)
        text = scan_for_user(text)
        text = scan_for_comment(text)
        return scan_for_spoiler(text)
    end
end

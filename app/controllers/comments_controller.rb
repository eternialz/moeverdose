class CommentsController < ApplicationController
    include ParserConcern

    before_action :set_post
    before_action :authenticate_user!

    def create
        @comment = Comment.create(params.require(:comment).permit(:text))
        length = @comment.text.length

        if (length > 1) && (length <= helpers.max_comment_length)
            @comment.text = scan_comment(@comment.text) # This can add to the length, so validations are not used

            @comment.user = current_user
            @post.comments << @comment
            @comment.post = @post

            if @post.save && @comment.save
                flash[:success] = 'Comment added.'
            else
                flash[:error] = 'Comment invalid.'
            end
        else
            flash[:error] = 'Comment invalid: please verify the length.'
        end

        redirect_to post_path(@post.number)
    end

    def report
        if (current_user && current_user != user)
            @comment = Comment.find(params[:comment_id])
            title('Report comment')
            render component 'posts/comment/report'
        else
            flash[:error] = 'You should be connected to report a comment'
            redirect_to root_path
        end
    end

    def report_update
        @comment = Comment.find(params[:comment_id])
        report = Report.new
        report.reason = params[:report][:reason]
        report.user = current_user
        report.reportable = @comment
        report.save
        @comment.reports << report
        @comment.save

        flash[:notice] = 'Comment reported'
        redirect_to post_path(@post.number)
    end

    private

    def set_post
        @post = Post.find_by(number: params[:post_id])
    end

    def scan_comment(text)
        # scan for posts, users and spoilers referenced in comments
        text = scan_for_post(text)
        text = scan_for_user(text)
        scan_for_spoiler(text)
    end
end

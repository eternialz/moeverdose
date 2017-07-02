class Admin::CommentsController < Admin::BaseController
    before_action :set_comment, except: [:index]

    layout 'admin'

    protected


    def index
        @comments = Comment.where(report: true)
    end

    def destroy
        @comment.destroy
        redirect_to admin_comments_path
    end

    def unreport
        @comment.report = false
        @comment.report_user = nil
        @comment.report_reason = ""
        if @comment.save
            flash[:notice] = "Comment unreported"
            render :index
        else
            flash[:error] = "An error occured"
            render :index
        end
    end

    protected

    def set_comment
        @comment = Comment.find(params[:id])
    end
end

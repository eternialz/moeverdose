module Admin
    class CommentsController < Admin::BaseController
        before_action :set_comment, except: [:index]

        layout 'admin'

        def index
            @comments = Kaminari.paginate_array(Comment.where(report: true)).page(params[:page]).per(20)
            render component 'admin/comments/index'
        end

        def destroy
            @comment.destroy
            redirect_to admin_comments_path
        end

        def unreport
            @comment.report = false
            @comment.report_user = nil
            @comment.report_reason = ''
            if @comment.save
                flash[:notice] = 'Comment unreported'
            else
                flash[:error] = 'An error occured'
            end
            redirect_to admin_comments_path
        end

        protected

        def set_comment
            @comment = Comment.find(params[:id])
        end
    end
end

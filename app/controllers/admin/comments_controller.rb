module Admin
    class CommentsController < Admin::BaseController
        before_action :set_comment, except: [:index]

        def index
            @reports = Report.includes(reportable: [:post, :user]).where(reportable_type: 'Comment')
            @comments = Kaminari.paginate_array(@reports.map(&:reportable).uniq).page(params[:page]).per(20)
            render component 'admin/comments/index'
        end

        def show
            @reports = Report.eager_load(:user).where(reportable_type: 'Comment', reportable_id: @comment.id)
            render component 'admin/comments/show'
        end

        def destroy
            @comment.reports.destroy_all
            @comment.destroy
            redirect_to admin_comments_path
        end

        def unreport
            @comment.reports.destroy_all
            if @comment.save
                flash[:notice] = 'Comment unreported'
            else
                flash[:error] = 'An error occured'
            end
            redirect_to admin_comments_path
        end

        protected

        def set_comment
            @comment = Comment.eager_load(:reports).find(params[:id])
        end
    end
end

class Admin::PostsController < Admin::BaseController
    before_action :set_post, except: [:index]

    def index
        @reports = Report.includes(reportable: [:user]).where(reportable_type: 'Post')
        @posts = Kaminari.paginate_array(@reports.map(&:reportable).uniq).page(params[:page]).per(20)

        render component 'admin/posts/index'
    end

    def show
        @reports = Report.includes(reportable: [:user]).where(reportable: @post)
        render component 'admin/posts/show'
    end

    def edit
        render component 'admin/posts/edit'
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
        @post.post_image.purge
        @post.reports.destroy_all
        @post.comments.destroy_all
        @post.destroy
        redirect_to admin_posts_path
    end

    def unreport
        @post.reports.destroy_all
        if @post.save
            flash[:notice] = 'The post has been unreported'
            redirect_to admin_posts_path
        else
            flash[:error] = 'An error occured, please try again'
            redirect_to admin_post_path(@post)
        end
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

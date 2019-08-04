class Admin::PostsController < Admin::BaseController
    before_action :set_post, except: [:index]

    def index
        @posts = Kaminari.paginate_array(Post.where(report: true).order('created_at DESC')).page(params[:page]).per(20)

        render component 'admin/posts/index'
    end

    def show
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
        @post.destroy
        redirect_to admin_posts_path
    end

    def unreport
        @post.report = false
        @post.report_user = nil
        @post.report_reason = ''
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

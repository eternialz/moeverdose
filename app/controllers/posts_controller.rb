class PostsController < ApplicationController
    before_action :try_set_post, only: [:show]
    before_action :set_post, only: [:edit, :update, :dose, :favorite, :report, :report_update]
    before_action :authenticate_user!, except: [:show, :index, :not_found, :random, :dose, :favorite]
    before_action :authenticate_user_xhr!, only: [:dose, :favorite]
    before_action :set_default_index_values, only: [:index]

    def show
        results = TagService.differenciate_tags(@post.tags)

        @tags = results[:tags]
        @characters = results[:characters]
        @authors = results[:authors]
        @copyrights = results[:copyrights]

        title(@post.title.present? ? @post.title : 'Post')

        if current_user
            @favorited = current_user.favorites.where(id: @post.id).empty? ? false : true
        end

        render component 'posts/show'
    end

    def index
        @posts = Kaminari.paginate_array(
            Post.sort_by_with_set(
                set_sort_by,
                PostService.search_posts(
                    params[:query],
                    user_signed_in? ? current_user.blacklisted_tags : nil
                )
            )
        ).page(params[:page]).per(items_per_page)

        @tags = []
        @characters = []
        @authors = []
        @copyrights = []
        @posts.each do |post|
            results = TagService.differenciate_tags(post.tags)
            @tags += results[:tags]
            @copyrights += results[:copyrights]
            @characters += results[:characters]
            @authors += results[:authors]
        end

        @comments_counts = Comment.where(post: @posts).group(:post_id).count

        @tags.uniq!
        @characters.uniq!
        @authors.uniq!

        @tags.sort_by! { |tag| tag }
        @characters.sort_by! { |character| character }
        @authors.sort_by! { |author| author }

        title('All posts')
        render component 'posts/index'
    end

    def new
        @post ||= Post.new
        @favorites_tags = current_user.favorites_tags&.map do |t|
            t.name
        end

        title('Upload')

        render component 'posts/new'
    end

    def create
        @post = Post.new(post_params)

        PostService.assign_id(@post)

        @post.md5 = @post.post_image.checksum

        PostService.set_post_tags({ tags: params[:tags], characters: params[:characters] }, @post)

        PostService.set_post_user(@post, current_user)

        unless params[:author].blank?
            author = TagService.find_or_create_author(params[:author], @post)
            @post.author = author
        end

        TagService.find_or_create(@post.source, :copyright, @post) unless @post.source.blank?

        file = params[:post][:post_image]
        image = MiniMagick::Image.new(file.path)
        @post.width = image.width
        @post.height = image.height

        binding.pry

        if @post.save
            TagService.change_counts(@post.tags, 1)

            flash[:success] = "Post #{@post.title} created!"
            notify('New post: ' + post_url(id: @post.number))

            redirect_to post_path(@post.number)
        else
            flash.now[:error] = 'The post could not be created.'

            render component 'posts/new'
        end
    end

    def edit
        results = TagService.differenciate_tags(@post.tags)
        @tags = results[:tags]
        @characters = results[:characters]
        @authors = results[:authors]

        title('Edit post ' + @post.number.to_s)
        render component 'posts/edit'
    end

    def update
        @post.assign_attributes(edit_post_params)

        @old_tags = Post.find_by(number: @post.number).tags
        TagService.change_counts(@old_tags, -1)

        @post.tags = []

        PostService.set_post_tags({ tags: params[:tags], characters: params[:characters] }, @post)

        if params[:author_tag].blank?
            @post.author = nil
        else
            author = TagService.find_or_create_author(params[:author_tag], @post)
            @post.author = author
        end

        if @post.save
            TagService.change_counts(@post.tags, 1) # Increase new tags post count

            flash[:success] = "Post id #{@post.number} updated!"
        else
            TagService.change_counts(@old_tags, 1) # Revert tags post count

            flash[:error] = 'Modifications could not be saved! Please verify informations provided'
        end

        redirect_to post_path(@post.number)
    end

    def not_found
        params[:id] = '0' if Integer(params[:id]) < 1
        title('404: Post id ' + params[:id] + ' not found')

        render component('posts/not-found'), status: 404
    end

    def random
        @post = Post.all.sample
        raise ActionController::RoutingError, 'No post found' unless @post

        redirect_to(post_path(@post.number))
    end

    def report
        if current_user
            title('Report post')
            render component 'posts/report'
        else
            flash[:error] = 'You should be connected to report a post'
            redirect_to root_path
        end
    end

    def report_update
        report = Report.new params.require(:report).permit(:reason)
        report.user = current_user
        report.reportable = @post
        report.save
        @post.reports << report
        @post.save

        flash[:notice] = 'Post reported'

        redirect_to post_path(@post.number)
    end

    def favorite
        if current_user.favorites.exclude?(@post)
            current_user.favorites << @post
            render json: { message: 'Post added to favorites', type: 'success' }, status: 200
        else
            current_user.favorites.delete(@post)
            render json: { message: 'Post removed from favorites', type: 'information' }, status: 200
        end
    end

    def dose
        @removed = false

        params[:dose] == 'overdose' ? overdose : shortage

        if @post.save
            render json: {
                message: params[:dose].capitalize + (@removed ? ' removed' : ' added'),
                type: @removed ? 'information' : 'success',
                overdose: @post.overdose,
                shortage: @post.moe_shortage
            }, status: 200
        else
            render json: {
                message: 'An internal error occured.',
                type: 'error'
            }, status: 500
        end
    end

    private

    def shortage
        if current_user.disliked_posts.exclude?(@post)
            if current_user.liked_posts.include?(@post)
                @post.overdose -= 1
                current_user.liked_posts.delete(@post)
            end
            @post.moe_shortage += 1
            current_user.disliked_posts << @post
        else
            @post.moe_shortage -= 1
            @removed = true
            current_user.disliked_posts.delete(@post)
        end
    end

    def overdose
        if current_user.liked_posts.exclude?(@post)
            if current_user.disliked_posts.include?(@post)
                @post.moe_shortage -= 1
                current_user.disliked_posts.delete(@post)
            end
            @post.overdose += 1
            current_user.liked_posts << @post
        else
            @post.overdose -= 1
            @removed = true
            current_user.liked_posts.delete(@post)
        end
    end

    def set_post
        @post = Post.eager_load(:comments, :tags, :reports).with_attached_post_image.find_by(number: params[:id]) if params[:id]
    end

    def try_set_post
        if params[:id]
            @post = Post.eager_load(:comments, :tags, :reports).with_attached_post_image.find_by(number: params[:id])

            not_found unless @post
        end
    end

    def post_params
        params.require(:post).permit(
            :title, :source, :post_image, :description, :width, :height
        )
    end

    def edit_post_params
        params.require(:post).permit(
            :title, :source, :description
        )
    end

    def set_sort_by
        params.permit(Post.sort_scopes).with_defaults(created_at: 'desc')
    end

    def notify(text)
        @url = ENV['DISCORD_WEBHOOK_POSTS_URL']

        @result = HTTParty.post(@url,
                                body: {
                                    content: text
                                }.to_json,
                                headers: { 'Content-Type' => 'application/json' })
    end
end

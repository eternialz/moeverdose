class PostsController < ApplicationController

    before_action :try_set_post, only: [:show]
    before_action :set_post, only: [:edit, :update, :dose, :favorite, :report, :report_update]
    before_action :authenticate_user!, except: [:show, :index, :not_found, :random]

    def show
        results = TagService.differenciate_tags(@post.tags)

        @tags = results[:tags]
        @characters = results[:characters]
        @authors = results[:authors]
        @copyrights = results[:copyrights]

        unless @post.title.blank?
            title(@post.title)
        else
            title("Post")
        end

        if current_user
            @favorited = current_user.favorites.where(id: @post.id).empty? ? false : true
        end

        render component "posts/show"
    end

    def index
        @permited_posts_per_page = ['8', '16', '24', '32']

        unless params[:posts_per_page].nil?
            @posts_per_page = params[:posts_per_page].to_i <= @permited_posts_per_page.last.to_i ? params[:posts_per_page] : '16'
        else
            @posts_per_page = '16'
        end

        unless params[:query].blank?
            if user_signed_in?
                @posts, ignored = PostService.query_with_blacklist(params[:query], current_user.blacklisted_tags, params[:page], @posts_per_page)
            else
                @posts, ignored = PostService.query(params[:query], params[:page], @posts_per_page)
            end

            if ignored
                flash.now[:info] = "One or more tags were ignored. Your query contains at least one tag which doesn't exist in our database."
            end
        else
            if user_signed_in?
                @posts = PostService.all_posts_with_blacklist(current_user.blacklisted_tags, params[:page], @posts_per_page)
            else
                @posts = PostService.all_posts(params[:page], @posts_per_page)
            end
        end

        @tags = []
        @characters = []
        @authors = []
        @copyrights = []
        @posts.each do |post|
            results = TagService.differenciate_tags(post.tags)
            @tags += results[:tags]
            @tags += results[:copyrights]
            @characters += results[:characters]
            @authors += results[:authors]
        end

        @comments_counts = Comment.where(post: @posts).group(:post_id).count

        @tags.uniq!
        @characters.uniq!
        @authors.uniq!

        @tags.sort_by!{ |tag| tag }
        @characters.sort_by!{ |character| character }
        @authors.sort_by!{ |author| author }

        title("All posts")
        render component "posts/index"
    end

    def new
        @post ||= Post.new
        @favorites_tags = current_user.favorites_tags&.map do |t|
            t.name
        end

        title("Upload")

        render component "posts/new"
    end

    def create
        @post = Post.new(post_params)

        PostService.set_id(@post)

        @post.post_image.attach(post_params[:post_image])

        @post.md5 = Digest::MD5.file(@post.post_image_path).hexdigest

        PostService.set_post_tags({tags: params[:tags], characters: params[:characters]}, @post)

        PostService.set_post_user(@post, current_user)

        unless params[:author].blank?
            author = TagService.find_or_create_author(params[:author], @post)
            @post.author = author
        end

        unless params[:source].blank?
            source = TagService.find_or_create(params[:source], :copyright, @post)
            @post.source = params[:source]
        end

        metadata = ActiveStorage::Analyzer::ImageAnalyzer.new(@post.post_image).metadata

        @post.width = metadata[:width];
        @post.height = metadata[:height];

        if @post.save
            TagService.change_counts(@post.tags, 1)

            flash[:success] = "Post #{@post.title} created!"
            notify("New post: " + post_url(id: @post.number))

            redirect_to post_path(@post.number)
        else
            flash.now[:error] = "The post could not be created."
            redirect_to new_post_path
        end
    end

    def edit
        results = TagService.differenciate_tags(@post.tags)
        @tags = results[:tags]
        @characters = results[:characters]
        @authors = results[:authors]

        title("Edit post: " + @post.title)
        render component "posts/edit"
    end

    def update
        @post.assign_attributes(edit_post_params)

        @old_tags = Post.find_by(number: @post.number).tags
        TagService.change_counts(@old_tags, -1)

        @post.tags = []

        PostService.set_post_tags({tags: params[:tags], characters: params[:characters]}, @post)

        unless params[:author_tag].blank?
            author = TagService.find_or_create_author(params[:author_tag], @post)
        end

        if @post.save
            author&.save

            TagService.change_counts(@post.tags, 1) # Increase new tags post count

            flash[:success] = "Post id #{@post.number} updated!"
        else
            TagService.change_counts(@old_tags, 1) # Revert tags post count

            flash[:error] = "Modifications could not be saved! Please verify informations provided"
        end

        redirect_to post_path(@post.number)
    end

    def not_found
        if Integer(params[:id]) < 1
            params[:id] = '0'
        end
        title("404: Post id " + params[:id] + " not found")

        render component("posts/not-found"), status: 404
    end

    def random
        @post = Post.all.sample
        redirect_to(post_path(@post.number))
    end

    def report
        render component "posts/report"
    end

    def report_update
        @post.assign_attributes(params.require(:post).permit(:report_reason))
        @post.report = true
        @post.report_user = current_user
        @post.save

        flash[:info] = "Post reported"

        redirect_to post_path(@post.number)
    end

    def favorite
        if user_signed_in?
            if current_user.favorites.exclude?(@post)
                current_user.favorites << @post
                render json: {message: "Post added to favorites", type: "success"}, status: 200
            else
                current_user.favorites.delete(@post)
                render json: {message: "Post removed from favorites", type: "information"}, status: 200
            end
        else
            render json: {message: "You need an account to add favorites", type: "warning"}, status: 403
        end
    end

    def dose
        if user_signed_in?
            @removed = false;

            params[:dose] == "overdose" ? overdose : shortage

            if @post.save
                render json: {
                    message: params[:dose].capitalize + (@removed ? " removed" : " added"),
                    type: @removed ? "information" : "success",
                    overdose: @post.overdose,
                    shortage: @post.moe_shortage
                }, status: 200
            else
                render json: {
                    message: "An internal error occured.",
                    type: "error"
                }, status: 500
            end
        else
            render json: {
                message: "You need an account to add overdose and/or shortage",
                type: "warning"
            }, status: 403
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
        if params[:id]
            @post = Post.find_by(number: params[:id])
        end
    end

    def try_set_post
        if params[:id]
            @post = Post.includes(:comments, :tags).find_by(number: params[:id])

            unless @post
                not_found
            end
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

    def set_user
      @user = User.includes(blacklisted_tags: :aliases).find(current_user.id)
    end

    def notify(text)
        @url = ENV["DISCORD_WEBHOOK_POSTS_URL"]

        @result = HTTParty.post(@url,
            :body => {
                :content => text
            }.to_json,
            :headers => { 'Content-Type' => 'application/json' }
        )
    end

    def set_params
        {
            "content" => "tttt"
        }
    end

end

class PostsController < ApplicationController
    require 'digest/md5'
    require 'httparty'
    require 'json'

    before_action :try_set_post, only: [:show]
    before_action :set_post, only: [:edit, :update, :dose, :favorite, :report]
    before_action :authenticate_user!, except: [:show, :index, :not_found, :random]

    def show
        post_logic = PostLogic.new(@post)
        results = post_logic.get_different_tags
        @tags = results[:tags]
        @characters = results[:characters]
        @authors = results[:authors]

        unless @post.title.blank?
            title(@post.title)
        else
            title("Post")
        end
    end

    def report
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
                head 200
            else
                current_user.favorites.delete(@post)
                head 202
            end
        else
            head 403
        end
    end

    def dose
        if user_signed_in?
            @removed = false;

            if params[:dose] == "overdose"
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
            else params[:dose] == "shortage"
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

            @post.save
            render json: {overdose: @post.overdose, shortage: @post.moe_shortage, removed: @removed}, status: 200
        else
            head 403
        end
    end

    def index
        @permited_posts_per_page = ['2', '8', '16', '32', '64']

        unless params[:posts_per_page].nil?
            @posts_per_page = params[:posts_per_page].to_i < @permited_posts_per_page.last ? params[:posts_per_page] : @permited_posts_per_page.last
        end

        unless params[:query].blank?
            if user_signed_in?
                @posts, ignored = PostLogic.query_with_blacklist(params[:query], current_user.blacklisted_tags, params[:page], @posts_per_page)
            else
                @posts, ignored = PostLogic.query(params[:query], params[:page], @posts_per_page)
            end

            if ignored
                flash.now[:info] = "One or more tags were ignored. Your query contains at least one tag which doesn't exist in our database."
            end
        else
            if user_signed_in?
                @posts = PostLogic.all_posts_with_blacklist(current_user.blacklisted_tags, params[:page], @posts_per_page)
            else
                @posts = PostLogic.all_posts(params[:page], @posts_per_page)
            end
        end

        @tags = []
        @characters = []
        @authors = []
        @posts.each do |post|
            post_logic = PostLogic.new(post)
            results = post_logic.get_different_tags
            @tags += results[:tags]
            @characters += results[:characters]
            @authors += results[:authors]
        end

        @tags.uniq!
        @characters.uniq!
        @authors.uniq!

        @tags.sort_by!{ |tag| tag }
        @characters.sort_by!{ |character| character }
        @authors.sort_by!{ |author| author }

        title("All posts")
    end

    def new
        @post ||= Post.new
        @favorites_tags = current_user.favorites_tags.split

        title("Upload")
    end

    def create
        @post = Post.new(post_params)

        PostLogic.set_id(@post)

        @post.md5 = Digest::MD5.file(@post.post_image.queued_for_write[:original].path).hexdigest

        PostLogic.set_post_tags({tags: params[:tags], characters: params[:characters]}, @post)

        PostLogic.set_post_dimensions(@post)

        PostLogic.set_post_user(@post, current_user)

        if params[:author] != "" && params[:author] != nil
            author = TagLogic.find_or_create_author(params[:author], @post)
        end

        if @post.save
            author&.save
            TagLogic.change_counts(@post.tags, 1)

            flash[:success] = "Post #{@post.title} created!"
            notify("New post: " + post_url(id: @post.number))

            redirect_to post_path(@post.number)
        else
            flash.now[:error] = "The post could not be created."

            render template: new_post_path
        end
    end

    def update
        @post.assign_attributes(edit_post_params)

        @old_tags = Post.find_by(number: @post.number).tags
        TagLogic.change_counts(@old_tags, -1)

        @post.tags = []

        PostLogic.set_post_tags({tags: params[:tags], characters: params[:characters]}, @post)

        unless params[:author_tag].blank?
            author = TagLogic.find_or_create_author(params[:author_tag], @post)
        end

        if @post.save
            author&.save

            TagLogic.change_counts(@post.tags, 1) # Increase new tags post count

            flash[:success] = "Post id #{@post.number} updated!"
        else
            TagLogic.change_counts(@old_tags, 1) # Revert tags post count

            flash[:error] = "Modifications could not be saved! Please verify informations provided"
        end

        redirect_to post_path(@post.number)
    end

    def not_found
        if Integer(params[:id]) < 1
            params[:id] = '0'
        end
        title("404: Post id " + params[:id] + " not found")

        render "posts/not_found", :status => 404
    end

    def random
        @post = Post.all.sample
        redirect_to(post_path(@post.number))
    end

    private
    def set_post
        if params[:id]
            @post = Post.find_by(number: params[:id])
        end
    end

    def try_set_post
        if params[:id]
            Mongoid.raise_not_found_error = false
            @post = Post.includes(:comments, :tags).find_by(number: params[:id])

            unless @post
                not_found
            end
        end
    end

    def post_params
        params.require(:post).permit(
            :title, :source, :post_image, :description
        )
    end

    def edit_post_params
        params.require(:post).permit(
            :title, :source, :description
        )
    end

    def set_user
        @user = User.find(current_user.id)
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

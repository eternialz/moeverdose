class PostsController < ApplicationController
    require 'digest/md5'

    before_action :try_set_post, only: [:show]
    before_action :set_post, only: [:edit, :update, :overdose, :shortage, :favorite, :report]
    before_action :authenticate_user!, only: [:update, :overdose, :shortage, :report, :favorite, :create, :new]

    def show
        @tags = []
        @characters = []
        @post.tags.each do |tag|
            if tag.content?
                @tags << tag.names[0]
            elsif tag.character?
                @characters << tag.names[0]
            end
        end
        if @post.overdose == 0 && @post.moe_shortage == 0
            @overdose = 50
            @shortage = 50
        else
            @overdose = @post.overdose / (@post.overdose + @post.moe_shortage).to_f * 100
            @shortage = 100 - @overdose
        end
    end

    def report
        @post.assign_attributes(params.require(:post).permit(:report_reason))
        @post.report = true
        @post.report_user = current_user
        @post.save
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

    def overdose
        if user_signed_in?
            if current_user.liked_posts.exclude?(@post)
                if current_user.disliked_posts.exclude?(@post)
                    @post.overdose += 1
                    @post.save
                    current_user.liked_posts << @post
                    head 200
                else
                    head 403
                end
            else
                @post.overdose -= 1
                @post.save
                current_user.liked_posts.delete(@post)
                head 202
            end
        else
            head 403
        end
    end

    def shortage
        if user_signed_in?
            if current_user.disliked_posts.exclude?(@post)
                if current_user.liked_posts.exclude?(@post)
                    @post.moe_shortage += 1
                    @post.save
                    current_user.disliked_posts << @post
                    head 200
                else
                    head 403
                end
            else
                @post.moe_shortage -= 1
                @post.save
                current_user.disliked_posts.delete(@post)
                head 202
            end
        else
            head 403
        end
    end

    def index
        @permited_posts_per_page = ['2', '8', '16', '32', '64']
        #Default posts per page
        @posts_per_page = "32"
        if !params[:posts_per_page].nil?
            # Custom number of posts per page
            if @permited_posts_per_page.include? params[:posts_per_page]
                @posts_per_page = params[:posts_per_page]
            end
        end

        params[:page] = params[:page].nil? ? 1 : params[:page]
        if params[:query]
            posts_tags_ids = Tag.where(:names.in => params[:query].split()).map do |t| t.id end
            @posts = Kaminari.paginate_array(Post.where(report: :false, :tag_ids.all => posts_tags_ids).order('created_at DESC')).page(params[:page]).per(@posts_per_page)
        else
            @posts = Kaminari.paginate_array(Post.where(report: :false).order('created_at DESC')).page(params[:page]).per(@posts_per_page)
        end

        @pages = []
        @current_page = params[:page].to_i
        (@current_page-3..@current_page+3).to_a.each do |page|
            if (page >= 1) && (page <= @posts.total_pages)
                @pages << page
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
        @tags = @tags.uniq
        @characters = @characters.uniq
        @authors = @authors.uniq

        @tags.sort_by!{ |tag| tag&.downcase }
        @characters.sort_by!{ |character| character&.downcase }
        @authors.sort_by!{ |author| author&.downcase }
    end

    def new
        @post ||= Post.new
        @favorites_tags = current_user.favorites_tags.split
    end

    def create
        @post = Post.new(post_params)

        begin
            @previous_post = Post.last
            @post.number = @previous_post.number + 1
        rescue
            @post.number = 1
        end

        tags = params[:tags].downcase.split(" ")

        tags.each do |tag|
            TagLogic.find_or_create(tag, :content, @post)
        end

        characters = params[:characters].downcase.split(" ")

        characters.each do |character|
            TagLogic.find_or_create(character, :character, @post)
        end

        dimensions = Paperclip::Geometry.from_file(@post.post_image.queued_for_write[:original].path)

        @post.md5 = Digest::MD5.file(@post.post_image.queued_for_write[:original].path).hexdigest

        @post.width = dimensions.width
        @post.height = dimensions.height

        @post.user = current_user
        user_logic = UserLogic.new(current_user)
        user_logic.update_level

        author = TagLogic.find_or_create_author(params[:author], @post)

        if @post.save
            @post.tags.each do |t|
                author.save
                t.posts_count += 1
                t.save
            end
            redirect_to post_path(@post.number)
        else
            redirect_to :back
        end
    end

    def update
        @post.assign_attributes(edit_post_params)

        @post.tags.each do |t|
            t.posts_count -= 1
            t.save
        end

        @post.tags = []
        author.save
        tags = params[:tags].downcase.split(" ")

        tags.each do |tag|
            TagLogic.find_or_create(tag, :content, @post)
        end

        characters = params[:characters].downcase.split(" ")

        characters.each do |character|
            TagLogic.find_or_create(character, :character, @post)
        end

        author_name = params[:author_tag]

        if author_name != "" && author_name != nil
            author = TagLogic.find_or_create_author(author_name, @post)
        end

        if @post.save
            @post.tags.each do |t|
                author.save
                t.posts_count += 1
                t.save
            end
        end
        redirect_to post_path(@post.number)
    end

    def not_found
        if Integer(params[:id]) < 1
            params[:id] = '0'
        end
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
            @post = Post.find_by(number: params[:id])

            unless @post
                not_found
            end
        end
    end

    def post_params
        params.require(:post).permit(
        :title, :source, :post_image
        )
    end

    def edit_post_params
        params.require(:post).permit(
        :title, :source
        )
    end

    def set_user
        @user = User.find(current_user.id)
    end
end

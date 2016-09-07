class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:update, :overdose, :shortage]
  before_action :set_post, only: [:edit, :update, :show, :overdose, :shortage, :favorite]

  def show
    @tags = []
    @characters = []
    @post.tags.each do |tag|
      if tag.content?
        @tags << tag.name
      elsif tag.character?
        @characters << tag.name
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
    @posts = Post.all
    @tags = []
    @characters = []
    @authors = []
    @posts.each do |post|
      post.tags.each do |tag|
        if tag.content? && !(@tags.include?(tag.name))
          @tags << tag.name
        elsif tag.character? && !(@characters.include?(tag.name))
          @characters << tag.name
        elsif tag.author? && !(@authors.include?(tag.name))
          @authors << tag.name
        end
      end
    end
  end

  def new
    @post ||= Post.new
  end

  def create
    @post = Post.new(post_params)

    tags = params[:tags].downcase.split(" ")

    tags.each do |tag|
      t = Tag.where(name: tag, type: :content)
      if t.empty?
        t = Tag.new({name: tag, type: :content})
      end
      @post.tags << t
    end

    characters = params[:characters].downcase.split(" ")

    characters.each do |character|
      c = Tag.where(name: character, type: :character)
      if c.empty?
        c = Tag.new({name: character, type: :character})
      end
      @post.tags << c
    end

    author_name = params[:author]
    author = Tag.where(name: author_name.downcase.tr(" ", "_"), type: :author)

    if author.empty?
      author = Tag.new({name: author_name.downcase.tr(" ", "_"),type: :author})
      author_profile = Author.new({name: author_name, posts: [@post]})
    else
      author_profile = Author.find_by({name: author_name})
      author_profile.posts << @post
    end

    @post.tags << author
    @post.author = author_profile

    dimensions = Paperclip::Geometry.from_file(@post.post_image.queued_for_write[:original].path)

    @post.width = dimensions.width
    @post.height = dimensions.height

    @post.user = current_user
    @post.user.upload_count += 1

    if @post.save
      author_profile.save
      @post.tags.each do |t|
        t.posts_count += 1
        t.save
      end
      redirect_to post_path(@post)
    else
      new
    end
  end

  def update
    @post.assign_attributes(edit_post_params)

    @post.tags = []
    tags = params[:tags].downcase.split(" ")

    tags.each do |tag|
      t = Tag.where(name: tag, type: :content)
      if t.empty?
        t = Tag.new({name: tag, type: :content})
      end
      @post.tags << t
    end

    characters = params[:characters].downcase.split(" ")

    characters.each do |character|
      c = Tag.where(name: character, type: :character)
      if c.empty?
        c = Tag.new({name: character, type: :character})
      end
      @post.tags << c
    end

    author_name = params[:author]

    if author_name != "" && author_name != nil
      author = Tag.where(name: author_name.downcase.tr(" ", "_"), type: :author)

      if author.empty?
        author = Tag.new({name: author_name.downcase.tr(" ", "_"),type: :author})
        author_profile = Author.new({name: author_name, posts: [@post]})
      else
        author_profile = Author.find_by({name: author_name})
        author_profile.posts << @post
      end
    end

    @post.tags << author
    @post.author = author_profile

    if @post.save
      author_profile.save
      @post.tags.each do |t|
        #t.posts_count =
        t.save
      end
    end
    redirect_to post_path(@post)
  end

  private
  def set_post
    if params[:id]
      @post = Post.find(params[:id])
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

class PostsController < ApplicationController

  before_action :set_post, only: [:edit, :update, :show, :destroy]

  def show
    @comments = [1]
    @tags = []
    @characters = []
    @post.tags.each do |tag|
      if tag.content?
        @tags << tag.name
      elsif tag.character?
        @characters << tag.name
      end
    end
  end

  def index
    @posts = Post.all
    @tags = []
    @characters = []
    @authors = []
    @posts.each do |post|
      post.tags.each do |tag|
        if tag.content?
          @tags << tag
        elsif tag.character?
          @characters << tag
        elsif tag.author?
          @authors << tag
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
      author_profile = Author.new({name: author_name.capitalize.tr(" ", "_"), posts: [@post]})
    else
      author_profile = Author.find_by({name: author_name})
      author_profile.posts << @post
    end

    @post.tags << author
    @post.author = author_profile

    dimensions = Paperclip::Geometry.from_file(@post.post_image.queued_for_write[:original].path)

    @post.width = dimensions.width
    @post.height = dimensions.height

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

  def destroy
    @post.destroy
  end

  def update
    @post.assign_attributes(edit_post_params)
    @post.save
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
end

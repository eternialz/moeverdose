class PostsController < ApplicationController

  before_action :set_post, only: [:edit, :update, :show, :destroy]

  def show
    @comments = [1]
    @post = Post.new
    @post.title="Titre du post"
    @post.source="Gj-Bu"
    @tags_normal = "1girl Blush_Eating Intruder Loli Ponytail Purple_hair Purple_eyes School_uniform"
    @tags_character = "Pochi nanodesu"
    @tag_author = "troll"
  end

  def index
    #@posts = Posts.all
  end

  def new
    #@post ||= Posts.new
  end

  def create

  end

  def destroy

  end

  def edit

  end

  def update

  end

  private
  def set_post
    if params[:id]
      #@question = FrequentlyAskedQuestion::Root.find(params[:id])
    end
  end

  def post_params
    params.require(:post).permit(
      :title, :source, :tags_normal, :tags_normal, :tag_author,
    )
  end

end

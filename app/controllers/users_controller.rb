class UsersController < ApplicationController
  before_action :set_user

  def show
    @user = User.find_by(name: params[:id])
    @posts = Post.all
  end

  def create
    redirect_to post_path(@user)
  end

  def new

  end

  def update

  end

  def destroy

  end
  private

  def set_user
    @user = User.find_by(name: params[:id])
  end
end

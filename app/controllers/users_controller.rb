class UsersController < ApplicationController
  before_action :set_user, except: [:index]

  def index
    if params[:page] != nil
      @current_page = params[:page].to_i
    else
      @current_page = 1
    end
    @users = User.all.order(upload_count:  :desc).page(params[:page]).per(50)
  end

  def show
    @user = User.find_by(name: params[:id])
    @favorites_tags = @user.favorites_tags.split(" ")
    @blacklisted_tags = @user.blacklisted_tags.split(" ")
    @level = @user.level
    @percentage = '%.2f' % ((@user.upload_count.to_f / @level.max_exp.to_f)*100)
    if @level.last == false
      @next_level = Level.find_by(rank: @level.rank + 1)
    else
      @next_level = Level.new(name: "No more levels")
    end
  end

  def update
    @user.update_attributes(account_update_params)
    tags = params[:tags]

    @user.favorites_tags = tags[:favorites]
    @user.blacklisted_tags = tags[:blacklisted]

    if @user.save
      redirect_to(user_path(@user.name))
    else
      redirect_to(edit_user_path(@user.name))
    end
  end

  def destroy

  end

  private
  def set_user
    @user = User.find_by(name: params[:id])
  end

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :avatar, :banner, :website, :facebook, :twitter, :biography)
  end
end

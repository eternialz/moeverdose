class UsersController < ApplicationController
  before_action :set_user

  def show
    @user = User.find_by(name: params[:id])
    @favorites_tags = @user.favorites_tags.split(" ")
    @blacklisted_tags = @user.blacklisted_tags.split(" ")
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
    binding.pry
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :avatar, :banner, :website, :facebook, :twitter, :biography)
  end
end

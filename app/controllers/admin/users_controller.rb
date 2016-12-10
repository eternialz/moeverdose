class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show, :edit, :update]

  def index
    @users = User.all
    if params[:report]
      @users = @users.where(report: params[:report])
    end
  end

  def show
  end

  def edit
  end

  def update
    user_params = params.require(:user).permit(
      :role, :report
    )
    @user.assign_attributes(user_params)
    if @user.save
      render @user
    else
      render :edit
    end
  end

  def destroy
  end

  private
  def set_user
    @user = User.find(params[:id])
  end
end

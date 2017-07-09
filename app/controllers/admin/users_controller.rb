class Admin::UsersController < Admin::BaseController
    before_action :set_user, except: [:index]

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

    def ban
        if @user.banned?
            @user.banned = false
            @user.save
            flash[:success] = "User unbanned"
        else
            if @user.role == :user
                @user.banned = true
                @user.save
                flash[:success] = "User banned"
            else
                flash[:error] = "The user isn't a regular user; change the role to user before deleting"
            end
        end

        redirect_to admin_users_path
    end

    private
    def set_user
        @user = User.find(params[:id])
    end
end

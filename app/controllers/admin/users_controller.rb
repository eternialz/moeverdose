class Admin::UsersController < Admin::BaseController
    before_action :set_user, except: [:index]

    def index
        @users = Kaminari.paginate_array(User.order('created_at DESC')).page(params[:page]).per(20)

        if params[:report]
            @users = @users.where(report: params[:report])
        end

        render component "admin/users/index"
    end

    def edit
        render component "admin/users/edit"
    end

    def update
        user_params = params.require(:user).permit(
            :role, :report
        )
        @user.assign_attributes(user_params)
        if @user.save
            redirect_to admin_users_path
        else
            redirect_to edit_admin_users_path(@user)
        end
    end

    def ban
        if @user.banned?
            @user.banned = false
            @user.save
            flash[:success] = "User unbanned."
        else
            if @user.role == 'user'
                @user.banned = true
                @user.save
                flash[:success] = "User banned."
            else
                flash[:error] = "The user isn't a regular user; change the role to user before banning."
            end
        end

        redirect_to admin_users_path
    end

    private
    def set_user
        @user = User.find(params[:id])
    end
end

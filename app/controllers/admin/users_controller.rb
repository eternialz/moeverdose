class Admin::UsersController < Admin::BaseController
    before_action :set_user, except: [:index]

    def index
        @reports = Report.includes(:reportable).where(reportable_type: 'User')
        @users = Kaminari.paginate_array(@reports.map(&:reportable).uniq).page(params[:page]).per(20)
        render component 'admin/users/index'
    end

    def show
        @reports = Report.eager_load(:user).where(reportable: @user)
        render component 'admin/users/show'
    end

    def edit
        render component 'admin/users/edit'
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

    def unreport
        @user.warnings.destroy_all
        if @user.save
            flash[:notice] = 'User unreported'
        else
            flash[:error] = 'An error occured'
        end
        redirect_to admin_users_path
    end

    def ban
        if @user.banned?
            @user.banned = false
            @user.save
            flash[:success] = 'User unbanned.'
        elsif @user.role == 'user'
            @user.banned = true
            @user.save
            flash[:success] = 'User banned.'
        else
            flash[:error] = "The user isn't a regular user; change the role to user before banning."
        end

        xhr_redirect_to admin_users_path
    end

    private

    def set_user
        @user = User.find(params[:id])
    end
end

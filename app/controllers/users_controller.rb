class UsersController < ApplicationController
    before_action :set_user, except: [:index]

    def show
        @current = (current_user == @user)
        @uploads = @user.posts.where(report: false).order(created_at: :desc).limit(6)
        @favs = @user.favorites.where(report: false).order(created_at: :desc).limit(6)
        @favorites_tags = @user.favorites_tags.split(" ")
        @blacklisted_tags = @user.blacklisted_tags.split(" ")
        @level = @user.level

        if (!@level.final)
            @next_level = Level.find_by(rank: @user.level.rank + 1)
        end

        title(@user.name + " profile")
    end

    def index
        @users = Kaminari.paginate_array(User.order('upload_count DESC')).page(params[:page]).per(20)

        title("All Users")
    end

    def update
        @user.update_attributes(account_update_params)
        tags = params[:tags]

        @user.favorites_tags = tags[:favorites]
        @user.blacklisted_tags = tags[:blacklisted]

        if @user.save
            flash[:success] = "Profile saved."

            redirect_to(user_path(@user.name))
        else
            flash[:error] = "Profile informations invalid. Please verify and try again."

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
        params.require(:user).permit(:email, :avatar, :banner, :website, :facebook, :twitter, :biography)
    end
end

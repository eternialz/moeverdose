class UsersController < ApplicationController
    before_action :authenticate_user!, only: [:edit, :update]
    before_action :set_user, except: [:index]
    before_action :check_user, only: [:edit, :update]
    before_action :permitted_per_page, only: [:favorites, :uploads]

    def show
        if @user.banned?
            title("Banned User")

            render 'users/banned'
        else
            @current = (current_user == @user)
            @favorites_tags = @user.favorites_tags.map do |t|
              t.name
            end
            @blacklisted_tags = @user.blacklisted_tags.map do |t|
              t.name
            end

            @level = @user.level
            if (!@level.final)
                @next_level = Level.find_by(rank: @user.level.rank + 1)
            end
        end

        title(@user.name + " profile")
    end

    def edit
        @favorites_tags = @user.favorites_tags.map do |t|
          t.name
        end.join(' ')
        @blacklisted_tags = @user.blacklisted_tags.map do |t|
          t.name
        end.join(' ')
        title("Edit my profile")
    end

    def favorites
        @posts = Kaminari.paginate_array(@user.favorites).page(params[:page]).per(@posts_per_page)
    end

    def uploads
        @posts = Kaminari.paginate_array(@user.posts).page(params[:page]).per(@posts_per_page)
    end

    def index
        @users = Kaminari.paginate_array(User.order('upload_count DESC')).page(params[:page]).per(20)

        title("All Users")
    end

    def update
        @user.update_attributes(account_update_params)
        tags = params[:tags]

        favorites_tags = Tag.includes(:aliases).where(aliases: { name: tags[:favorites].split().uniq() }) # remove duplicates
        blacklisted_tags = Tag.includes(:aliases).where(aliases: { name: tags[:blacklisted].split().uniq() })

        @user.favorites_tags = favorites_tags
        @user.blacklisted_tags = blacklisted_tags

        if @user.save
            flash[:success] = "Profile saved."

            redirect_to(user_path(@user.name))
        else
            flash[:error] = "Profile informations invalid. Please verify and try again."

            redirect_to(edit_user_path(@user.name))
        end
    end

    private
    def set_user
        @user = User.includes(favorites_tags: :aliases, blacklisted_tags: :aliases).find_by(name: params[:id])
    end

    def check_user
        if current_user != @user
            flash[:error] = "The user you tried to edit isn't yourself"
            redirect_to edit_user_path(current_user.name)
        end
    end

    def permitted_per_page
        @permited_posts_per_page = ['2', '8', '16', '32', '64']

        if !params[:posts_per_page].nil?
            @posts_per_page = params[:posts_per_page]
        end
    end

    def sign_up_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def account_update_params
        params.require(:user).permit(:email, :avatar, :banner, :website, :facebook, :twitter, :biography)
    end
end

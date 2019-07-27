class UsersController < ApplicationController
    before_action :authenticate_user!, only: [:edit, :update]
    before_action :set_user, except: [:index]
    before_action :check_user, only: [:edit, :update]
    before_action :permitted_per_page, only: [:favorites, :uploads]

    def index
        if params[:query]
            @users = Kaminari.paginate_array(
                User.order('upload_count DESC').where('name LIKE ?', "%#{params[:query]}%" ))
                .page(params[:page]).per(20)
        else
            @users = Kaminari.paginate_array(User.order('upload_count DESC')).page(params[:page]).per(20)
        end


        title("All Users")
        render component "users/index"
    end

    def show
        unless @user
            raise ActionController::RoutingError.new('Not Found')
        end

        if @user.banned?
            title("Banned User")

            render component 'users/banned'
        else
            @current = (current_user == @user)
            @favorites_tags = @user.favorites_tags.map do |t|
              t.name
            end
            @blacklisted_tags = @user.blacklisted_tags.map do |t|
              t.name
            end

            title(@user.name + " profile")

            render component "users/show"
        end
    end

    def edit
        @favorites_tags = @user.favorites_tags.map do |t|
          t.name
        end.join(' ')
        @blacklisted_tags = @user.blacklisted_tags.map do |t|
          t.name
        end.join(' ')

        @permissions = @user.permissions

        @permissions_types = PermissionsType.all
        @permissions_types.each do |pt|
            if @permissions.select { |p| p.permissions_type_id == pt.id }.empty?
                @user.permissions.build(consent: false, permissions_type_id: pt.id)
            end
        end

        title("Edit my profile")

        render component "users/edit"
    end

    def favorites
        @posts = Kaminari.paginate_array(@user.favorites).page(params[:page]).per(@posts_per_page)
        @comments_counts = Comment.where(post: @posts).group(:post_id).count

        @breadcrumbs = [
            {
                name: @user.name,
                path: user_path(@user.name)
            },
            {
                name: "favorites",
                path: favorites_path(@user.name)
            }
        ]

        render component "users/favorites"
    end

    def uploads
        @posts = Kaminari.paginate_array(@user.posts).page(params[:page]).per(@posts_per_page)
        @comments_counts = Comment.where(post: @posts).group(:post_id).count

        @breadcrumbs = [
            {
                name: @user.name,
                path: user_path(@user.name)
            },
            {
                name: "uploads",
                path: uploads_path(@user.name)
            }
        ]

        render component "users/uploads"
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
        @user = User.left_outer_joins(favorites_tags: :aliases, blacklisted_tags: :aliases, permissions: :permissions_type).find_by(name: params[:id])
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
        params.require(:user).permit(:email, :avatar, :banner, :website,
            :facebook, :twitter, :biography,
            permissions_attributes: [:id, :consent, :permissions_type_id])
    end
end

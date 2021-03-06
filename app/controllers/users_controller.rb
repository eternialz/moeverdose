class UsersController < ApplicationController
    before_action :authenticate_user!, only: [:edit, :update, :delete, :report, :report_update, :claims]
    before_action :set_user, except: [:index]
    before_action :check_user, only: [:edit, :update, :delete, :extract, :claims]
    before_action(only: [:index]) { set_default_index_values }

    def index
        @users = if params[:query]
                     Kaminari.paginate_array(
                         User.sort_by(set_sort_by).where('name LIKE ?', "%#{params[:query]}%")
                     )
                             .page(params[:page]).per(@items_per_page)
                 else
                     Kaminari.paginate_array(User.sort_by(set_sort_by)).page(params[:page]).per(@items_per_page)
                 end

        title('All Users')
        render component 'users/index'
    end

    def show
        raise ActionController::RoutingError, 'Not Found' unless @user

        if @user.banned?
            title('Banned User')

            render component 'users/banned'
        else
            @current = (current_user == @user)
            @favorites_tags = @user.favorites_tags.map(&:name)
            @blacklisted_tags = @user.blacklisted_tags.map(&:name)

            title(@user.name + ' profile')

            render component 'users/show'
        end
    end

    def edit
        @favorites_tags = @user.favorites_tags.map(&:name).join(' ')
        @blacklisted_tags = @user.blacklisted_tags.map(&:name).join(' ')

        @permissions = @user.permissions

        @permissions_types = PermissionsType.all
        @permissions_types.each do |pt|
            if @permissions.select { |p| p.permissions_type_id == pt.id }.empty?
                @user.permissions.build(consent: false, permissions_type_id: pt.id)
            end
        end

        title('Edit my profile')

        render component 'users/edit'
    end

    def favorites
        @posts = Kaminari.paginate_array(
            Post.sort_by_with_set(
                set_post_sort_by,
                @user.favorites
            )
        ).page(params[:page]).per(items_per_page)

        @comments_counts = Comment.where(post: @posts).group(:post_id).count

        @breadcrumbs = [
            {
                name: @user.name,
                path: user_path(@user.name)
            },
            {
                name: 'favorites',
                path: user_favorites_path(@user.name)
            }
        ]

        render component 'users/favorites'
    end

    def claims
        @emitted_claims = Kaminari.paginate_array(
            Claim.where(user: current_user).order(created_at: :desc)
        ).page(params[:page]).per(@items_per_page)

        @received_claims = Kaminari.paginate_array(
            Claim.where(status: :open).joins(:post).where(posts: { user: current_user }).order(created_at: :desc)
        ).page(params[:page]).per(@items_per_page)

        render component 'users/claims'
    end

    def uploads
        @posts = Kaminari.paginate_array(
            Post.sort_by_with_set(
                set_post_sort_by,
                @user.posts
            )
        ).page(params[:page]).per(items_per_page)

        @comments_counts = Comment.where(post: @posts).group(:post_id).count

        @breadcrumbs = [
            {
                name: @user.name,
                path: user_path(@user.name)
            },
            {
                name: 'uploads',
                path: user_uploads_path(@user.name)
            }
        ]

        render component 'users/uploads'
    end

    def update
        @user.update(account_update_params)
        tags = params[:tags]

        favorites_tags = Tag.includes(:aliases).where(aliases: { name: tags[:favorites].split.uniq })
        blacklisted_tags = Tag.includes(:aliases).where(aliases: { name: tags[:blacklisted].split.uniq })

        @user.favorites_tags = favorites_tags
        @user.blacklisted_tags = blacklisted_tags

        if @user.save
            flash[:success] = 'Profile saved.'

            redirect_to(user_path(@user.name))
        else
            flash[:error] = 'Profile informations invalid. Please verify and try again.'

            redirect_to(edit_user_path(@user.name))
        end
    end

    def extract
        user_json = UserService.get_personal_infos(@user.name)
        zip_file = ZipService.create_from_json(user_json, 'user', 'data')
        respond_to do |format|
            format.zip do
                send_data(zip_file, type: 'application/zip', filename: 'data.zip')
            end
        end
    end

    def delete
        @user.deleted_at = DateTime.now.to_date

        if @user.valid_password?(params[:user][:password])
            if @user.save
                flash[:success] = 'Your account has been successfully flagged for deletion.'
                sign_out @user
                redirect_to root_path
            else
                flash[:error] = 'There was a problem when trying to flag your account as deleted.'
            end
        else
            @user.errors.add(:password, "provided doesn't match.")
            render component 'users/edit'
        end
    end

    def report
        if current_user != @user && !@user.team?
            title('Report user')
            render component 'users/report'
        else
            flash[:error] = 'You cannot report this user'
            redirect_to user_path(@user.name)
        end
    end

    def report_update
        if current_user && current_user != @user && !@user.team?
            report = Report.new
            report.reason = params[:report][:reason]
            report.user = current_user
            report.reportable = @user
            report.save
            @user.warnings << report
            @user.save

            flash[:notice] = 'User reported'
        else
            flash[:error] = 'You cannot report this user'
        end

        redirect_to user_path(@user.name)
    end

    private

    def set_user
        @user = User.left_outer_joins(
            favorites_tags: :aliases,
            blacklisted_tags: :aliases,
            permissions: :permissions_type
        ).find_by(name: params[:id])
    end

    def check_user
        if current_user != @user
            flash[:error] = "You can't access another's profile options."
            redirect_to edit_user_path(current_user.name)
        end
    end

    def set_sort_by
        params.permit(User.sort_scopes).with_defaults(posts: 'desc')
    end

    def set_post_sort_by
        params.permit(Post.sort_scopes).with_defaults(created_at: 'desc')
    end

    def account_update_params
        params.require(:user).permit(:email, :avatar, :banner, :website,
                                     :facebook, :twitter, :biography,
                                     permissions_attributes: [:id, :consent, :permissions_type_id])
    end
end

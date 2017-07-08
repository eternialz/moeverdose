class UsersController < ApplicationController
    before_action :set_user, except: [:index]

    def show
        @current = (current_user == @user)
        @uploads = @user.posts.where(report: false).order(created_at: :desc).limit(6)
        @favs = @user.favorites.where(report: false).order(created_at: :desc).limit(6)
        @favorites_tags = @user.favorites_tags.split(" ")
        @blacklisted_tags = @user.blacklisted_tags.split(" ")
        @level = @user.level
        @percentage = '%.2f' % ((@user.upload_count.to_f / @level.max_exp.to_f)*100)
        if (@percentage.to_i > 100)
            @percentage = "100"
        end
        if @level.final == false
            @next_level = Level.find_by(rank: @level.rank + 1)
            @to_next = ''
        else
            @next_level = Level.new(name: "No more levels")
            @to_next = '<p style="text-align: center;"><%= @level.max_exp - @user.upload_count %> upload(s) until next level</p>'
        end
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
        params.require(:user).permit(:email, :password, :password_confirmation, :avatar, :banner, :website, :facebook, :twitter, :biography)
    end
end

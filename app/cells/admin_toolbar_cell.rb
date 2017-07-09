class AdminToolbarCell < Cell::ViewModel

    def show_post
        if check_role
            render :show_post
        end
    end

    def show_user
        if check_role
            render :show_user
        end
    end

    private

    def check_role
        return options[:role] != :user
    end
end

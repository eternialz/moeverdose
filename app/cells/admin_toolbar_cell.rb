class AdminToolbarCell < Cell::ViewModel

    def show_post
        if options[:role] != "user"
            render :show_post
        end
    end

    def show_user
        if options[:role] != "user"
            render :show_user
        end
    end
end

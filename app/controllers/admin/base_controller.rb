module Admin
    class BaseController < ApplicationController

        before_action :admin_user?
        layout 'admin'

        protected

        def admin_user?
            authenticate_user!
            if !current_user&.administrator?
                redirect_to root_path
            end
        end

        def admin_active_link?(path)
            return helpers.current_page?(path) ? "active admin-menu-link" : "admin-menu-link"
        end
        helper_method :admin_active_link?
    end
end

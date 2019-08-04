module Admin
    class BaseController < ApplicationController
        before_action :admin_user?
        layout 'admin'

        protected

        def admin_user?
            authenticate_user!
            redirect_to root_path unless current_user&.administrator?
        end

        def admin_active_link?(path)
            helpers.current_page?(path) ? 'active admin-menu-link' : 'admin-menu-link'
        end
        helper_method :admin_active_link?
    end
end

class Admin::BaseController < ApplicationController

    before_action :admin_user?
    layout 'admin'

    protected

    def admin_user?
        authenticate_user!
        if !current_user&.administrator?
            redirect_to root_path
        end
    end
end

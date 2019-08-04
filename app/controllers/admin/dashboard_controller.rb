class Admin::DashboardController < Admin::BaseController
    def index
        render component 'admin/dashboard/index'
    end

    def stats
        render component 'admin/dashboard/stats'
    end
end

class TeamsController < ApplicationController
    def index
        title("Team")
        @users = User.where(role: ['administrator', 'moderator', 'developper'])
        @breadcrumbs = [
            {
                name: helpers.site_name,
                path: root_path
            },
            {
                name: "Team",
                path: "/team"
            }
        ]

        render component "team"
    end
end

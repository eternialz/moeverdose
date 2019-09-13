class TeamsController < ApplicationController
    def index
        title('Team')
        @users = User.where(role: User::Role.team)
        @breadcrumbs = [
            {
                name: helpers.site_name,
                path: root_path
            },
            {
                name: 'Team',
                path: '/teams'
            }
        ]

        render component 'team'
    end
end

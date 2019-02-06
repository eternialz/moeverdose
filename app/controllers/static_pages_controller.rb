class StaticPagesController < ApplicationController
    def static
        title((params[:page].capitalize).to_s)
        @breadcrumbs = static_breadcrumbs().push({
            name: params[:page],
            path: "/#{params[:page]}"
        })

        render component "static/#{params[:page]}"
    end

    def wiki
        title("Wiki - #{params[:page].capitalize}")
        @breadcrumbs = help_breadcrumbs().push({
            name: params[:page],
            path: "/wiki/#{params[:page]}"
        })

        render component "static/wiki/#{params[:page]}"
    end

    def team
        title("Team")
        @users = User.where(role: ['administrator', 'moderator', 'developper'])
        @breadcrumbs = static_breadcrumbs().push({
            name: "Team",
            path: "/team"
        })

        render component "team"
    end

    private
    def static_breadcrumbs
        return [
            {
                name: helpers.site_name,
                path: root_path
            }
        ]
    end

    def help_breadcrumbs
        return static_breadcrumbs.push(
            {
                name: "wiki",
                path: "/wiki/index"
            }
        )
    end
end

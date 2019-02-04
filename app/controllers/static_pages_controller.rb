class StaticPagesController < ApplicationController
    def static
        title("#{params[:page].capitalize}")
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

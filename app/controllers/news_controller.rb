class NewsController < ApplicationController
    def show
        @new = New.find(params[:id])
        title(@new.title)

        @breadcrumbs = [
            {
                name: helpers.site_name,
                path: root_path,
            },
            {
                name: "news",
                path: root_path + "#news",
            },
            {
                name: @new.title,
                path: news_path(@new),
            }
        ]

        render component "new"
    end
end

class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    prepend_view_path Rails.root.join("frontend")

    def home
        @news = New.all.order('created_at DESC').limit(2)
        render helpers.componentPath("home")
    end

    private
    def title(page_title)
        if page_title.to_s != ""
            @title = page_title.to_s + ' - ' + helpers.site_name
        end
    end
end

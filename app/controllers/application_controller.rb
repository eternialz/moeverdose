class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    def home
        @news = New.all.desc('created_at').limit(2)
        render "/home"
    end

    private
    def title(page_title)
        if page_title.to_s != ""
            @title = page_title.to_s + ' - ' + helpers.site_name
        end
    end
end

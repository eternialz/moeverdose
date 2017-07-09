class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    private
    def title(page_title)
        if page_title.to_s != ""
            @title = page_title.to_s + ' - ' + helpers.site_name
        end
    end
end
